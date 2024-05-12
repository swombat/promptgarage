class PromptExecution < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :prompt
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :prompt
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :label, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def arguments=(args)
    self.parameters_summary = args.to_json
    self.compiled_parameters = {
      prompt: prompt.compiled_prompt(args),
      model: model
    }.to_json
    save # if persisted?
  end

  def parameters_summary_enriched
    json_summary = JSON.parse(parameters_summary)
    json_summary.each_key do |key|
      next if json_summary[key].blank?
      json_summary[key] = "[" + InputItem.where(id: json_summary[key].collect(&:to_i)).collect { |item| item.as_string(preview: true, expanded_tags: false) }.join(", ") + "]"
    end
    json_summary.to_json
  end

  def execute

  end
  # 🚅 add methods above.
end
