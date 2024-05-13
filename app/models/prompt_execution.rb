class PromptExecution < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :prompt
  # 🚅 add belongs_to associations above.

  has_many :outputs, dependent: :destroy, enable_cable_ready_updates: true
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

  def inputs_used
    json_summary = JSON.parse(parameters_summary)
    inputs = []
    json_summary.each_key do |key|
      next if json_summary[key].blank?
      puts json_summary[key]
      inputs << InputItem.where(id: json_summary[key].collect(&:to_i))
    end
    inputs.flatten
  end

  def execute
    output = outputs.create(label: "#{self.label}-#{Time.now.to_i}")
    AsyncAiProcessJob.perform_later(id, output.id)
    return output
  end

  def execute_async(output)
    api = team.api_for(model)
    response = api.get_response(
      params: JSON.parse(compiled_parameters),
      stream_proc: Proc.new { |incremental_response| output.update_attribute(:results, incremental_response) },
      stream_response_type: :text
    )

    output.message_id_api = response["id"]
    output.output_tokens = response["usage"]["output_tokens"]
    output.input_tokens = response["usage"]["input_tokens"]
    output.save

    inputs_used.each { |input| input.update_attribute(:used, true) }

    Rails.logger.debug(response.inspect)
  end
  # 🚅 add methods above.
end
