require "rouge"

module ApplicationHelper
  include Helpers::Base

  def current_theme
    :light
  end

  def pretty_print_json(json)
    formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    lexer = Rouge::Lexers::JSON.new
    formatter.format(lexer.lex(JSON.pretty_generate(JSON.parse(json))))
  end

  def pretty_print_markdown(markdown)
    formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    lexer = Rouge::Lexers::Markdown.new
    formatter.format(lexer.lex(markdown))
  end

  def api_key_mask(api_key)
    api_key[0..3] + "****" + api_key[-4..-1]
  end
end
