require 'anthropic'
require 'http'
require 'json'

class ClaudeApi < LlmApi
  def initialize(access_token:)
    super()
    @api_key = access_token
    @client = Anthropic::Client.new(access_token: @access_token)
  end

  def models
    %w(claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307)
  end

  # Expected in +params+:
  # - :prompt
  # - :model
  # - :system (optional)
  # - :format (optional)
  # - :max_tokens (optional)
  def get_response(params:, stream_proc:, stream_response_type:)
    client = HTTP.headers({
      'x-api-key' => @access_token,
      'anthropic-version' => '2023-06-01',
      'Content-Type' => 'application/json'
    }).timeout(connect: 20, write: 20, read: 30)

    stream_url = 'https://api.anthropic.com/v1/messages'

    arguments = {
      model: params[:model],
      temperature: 0.9,
      system: params[:system] || nil,
      max_tokens: params[:max_tokens] || 4096,
      messages: [{ 'role': 'user', 'content': params[:prompt] }],
      stream: true
    }

    arguments[:messages] << { 'role': 'assistant', 'content': params[:format] } if params[:format].present?

    response = client.post(stream_url, body: JSON.generate(arguments))
    latest_item = ''
    parse_stream_response(response) do |_incremental_response, delta|
      if json
        latest_item += delta
        if latest_item.include?("}")
          begin
            stream_proc.call(JSON.parse(latest_item.match(/\{(?:[^{}]|\g<0>)*\}/)[0]))
          rescue JSON::ParserError => e
            Rails.logger.error "*** Error parsing JSON: #{e}"
            Rails.logger.error '*** skipping item and carrying on.'
            Rails.logger.error "the item was: #{latest_item}"
          end
          latest_item = ''
        end
      else
        stream_proc.call(_incremental_response, delta)
      end
    end
  end

  # Returns the incremental response as plain text, bit by bit, along with the latest delta
  # Only considers the content_block_delta events.
  def parse_stream_response(response, &block)
    incremental_response = ''
    response.body.each do |chunk|
      next if chunk.strip.empty?

      chunk.split("\n").each_with_index do |line, index|
        unless line.start_with?('data: ')
          # Rails.logger.info "Skipping line (doesn't start with data) #{index} - #{line}"
          next
        end

        begin
          json_data = JSON.parse(line.gsub('data: ', ''))
        rescue JSON::ParserError => e
          Rails.logger.error "*** Error parsing JSON: #{e}"
          Rails.logger.error '*** skipping item and carrying on.'
          Rails.logger.error "the line was: #{line}"
          next
        end

        unless json_data['type'] == 'content_block_delta'
          Rails.logger.info "Skipping line (not content_block_delta) #{index} - #{line}"
          next
        end

        incremental_response += json_data['delta']['text']
        delta = json_data['delta']['text']
        yield incremental_response, delta
      end
    end
  end
end

LlmApi.register(ClaudeApi)
