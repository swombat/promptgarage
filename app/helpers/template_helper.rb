module TemplateHelper
  def tpl(text, color: "blue")
    simple_format(highlight_set_placeholder(highlight_placeholder(text, color: color)))
  end

  def highlight_placeholder(text, color: "blue")
    text.gsub(/{{[^{}]+}}/) { |match| "<span class='bg-#{color}-100 rounded-md border-#{color}-200 border-2'>#{match}</span>" }
  end

  # TODO: Well this is a mess... fix it at some point... find a better way to highlight parameters that have been
  # set differently from those that haven't...
  def highlight_set_placeholder(text, color: "green")
    text.gsub(/\[\{\[\{.*?\}\]\}\]/) { |match| "<span class='bg-#{color}-100 rounded-md border-#{color}-200 border-2'>#{match}</span>" }.
      gsub("\[\{\[\{", "{{").gsub("\}\]\}\]", "}}")
  end
end
