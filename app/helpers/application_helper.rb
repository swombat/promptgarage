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
end
