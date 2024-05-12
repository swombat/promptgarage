require 'anthropic'

class ClaudeApi < LlmApi
  def initialize(access_token:)
    @api_key = access_token
    @client = Anthropic::Client.new(access_token: @access_token)
  end

  def models
    %w(claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307)
  end
end

LlmApi.register(ClaudeApi)
