class ClaudeApi < LlmApi
  def initialize
  end

  def models
    %w(claude-3-opus-20240229 claude-3-sonnet-20240229 claude-3-haiku-20240307)
  end
end

LlmApi.register(ClaudeApi)
