require 'openai'

class OpenAiApi < LlmApi
  def initialize(access_token:)
    super()
    @access_token = access_token
    @client = OpenAI::Client.new(access_token: @access_token)
  end

  def models
    @models ||= @client.models.list["data"]
      .select { |model| model["id"].starts_with?("gpt") }
      .sort_by { |model| model["created"] }.reverse
      .collect { |model| model["id"] }
  end

  def get_response(params:, stream_proc:, stream_response_type:)
    params = params.transform_keys(&:to_sym)
    incremental_response = ""
    raise "Unsupported stream response type #{stream_response_type}" unless [:text].include?(stream_response_type)
    response = {
      usage: {
        input_tokens: OpenAI.rough_token_count("#{params[:system]} #{params[:user]}"),
        output_tokens: 0,
      },
      id: nil
    }

    parameters = {
      model: params[:model],
      messages: [],
      temperature: params[:temperature] || 0.7,
      stream: proc do |chunk, _bytesize|
        response[:id] = chunk["id"] if response[:id].nil? && chunk["id"].present?
        if stream_response_type == :text
          delta = chunk.dig("choices", 0, "delta", "content")
          next if delta.nil?
          puts response.inspect
          response[:usage][:output_tokens] += 1
          incremental_response += delta
          stream_proc.call(incremental_response, delta)
        end
      end
    }

    parameters[:messages] << { role: "system", content: params[:system] } if params[:system]
    parameters[:messages] << { role: "user", content: params[:user] } if params[:user]
    @client.chat(parameters: parameters)

    # Fake it for now
    response[:choices] = [ { index: 0, message: {
                                            role: "assistant",
                                            content: incremental_response
                                          },
                              finish_reason: "stop"} ]

    JSON.parse(response.to_json)
  end
end

LlmApi.register(OpenAiApi)
