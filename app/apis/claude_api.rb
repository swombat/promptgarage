require 'anthropic'
require 'json'

class ClaudeApi < LlmApi
  def initialize(access_token:)
    super()
    @access_token = access_token
    @client = Anthropic::Client.new(access_token: @access_token)
  end

  def models
    %w(claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307)
  end

  # Expected in +params+:
  # - :user - user prompt
  # - :model
  # - :system (optional)
  # - :format (optional)
  # - :max_tokens (optional)
  def get_response(params:, stream_proc:, stream_response_type:)
    params = params.transform_keys(&:to_sym)
    parameters = {
      model: params[:model],
      temperature: 0.9,
      max_tokens: params[:max_tokens] || 4096,
      messages: [],
      stream: stream_proc,
      preprocess_stream: stream_response_type
    }
    debug(parameters.inspect, "parameters")

    parameters[:messages] << { 'role': 'user', 'content': params[:user] } if params[:user]
    parameters[:messages] << { 'role': 'assistant', 'content': params[:format] } if params[:format].present?
    parameters[:system] = params[:system] if params[:system].present?

    response = @client.messages(parameters: parameters)
    response
  end
end

LlmApi.register(ClaudeApi)
