require 'openai'

class OpenAiApi < LlmApi
  def initialize(access_token:)
    @access_token = access_token
    @client = OpenAI::Client.new(access_token: @access_token)
  end

  def models
    @models ||= @client.models.list["data"].
      select { |model| model["id"].starts_with?("gpt") }.
      sort_by { |model| model["created"] }.reverse.
      collect { |model| model["id"] }
  end

  def get_response(params:, stream_proc:, stream_response_type:)
    # Just a stub for now to build the rest
    return {
      "id": "chatcmpl-8P7s1c2QVZW1Uqqd11S0cB78LBvoA",
      "object": "chat.completion",
      "created": 1700999145,
      "model": "gpt-3.5-turbo-0613",
      "choices": [
        {
          "index": 0,
          "message": {
            "role": "assistant",
            "content": "Hi there! How can I assist you today?"
          },
          "finish_reason": "stop"
        }
      ],
      "usage": {
        "prompt_tokens": 9,
        "completion_tokens": 10,
        "total_tokens": 19
      }
    }
    # if stream_proc
    #   @client.chat.completions.create(params.merge(stream: true)) do |response|
    #     stream_proc.call(response, stream_response_type)
    #   end
    # else
    #   @client.chat.completions.create(params)
    # end
  end
end

LlmApi.register(OpenAiApi)
