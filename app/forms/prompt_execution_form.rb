class PromptExecutionForm
  include ActiveModel::Model

  attr_accessor :prompt, :params, :label, :model

  def initialize(prompt:, params:nil, label:nil, model:nil)
    self.prompt = prompt
    self.params = params
    self.label = label
    self.model = model

    prompt.arguments.each do |argument|
      singleton_class.class_eval do
        attr_accessor argument.underscore.to_sym
      end
    end
  end

  def arguments
    prompt.arguments
  end

  def input_types
    prompt.project.input_types
  end

  def inputs
    prompt.project.input_items
  end

  def input_item_choices
    prompt.project.input_items.collect { |item| ["#{item.name} (#{item.type.name})", item.id] }
  end

  def model_choices
    prompt.project.team.available_models
  end

  def form_input_item_ids
    arguments.collect { |arg| self.send(arg.underscore.to_sym) }.flatten.compact.uniq
  end

  def all_objects
    InputItem.where(id: form_input_item_ids) + [prompt]
  end
end
