require 'ruby-openai'

class OpenAiApi < LlmApi
  def initialize(access_key:)
    @access_key = access_key
    @client = OpenAI::Client.new(access_token: @access_key)
  end

  def models
    @models ||= @client.models.list["data"].
      select { |model| model["id"].starts_with?("gpt") }.
      sort_by { |model| model["created"] }.reverse.
      collect { |model| model["id"] }
  end
end
