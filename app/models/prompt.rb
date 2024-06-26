class Prompt < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :project
  belongs_to :parent, class_name: "Prompt", optional: true
  # 🚅 add belongs_to associations above.

  has_many :prompt_sections, dependent: :destroy, enable_cable_ready_updates: true
  has_many :prompt_executions, dependent: :destroy, enable_cable_ready_updates: true
  # 🚅 add has_many associations above.

  has_one :team, through: :project
  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :parent, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def fork
    new_prompt = project.prompts.create(name: "#{name} (forked)")
    new_prompt.parent = self
    new_prompt.save
    prompt_sections.each do |section|
      new_prompt.prompt_sections.create(
        name: section.name,
        contents: section.contents,
        sort_order: section.sort_order,
        system_prompt: section.system_prompt
      )
    end
    new_prompt
  end

  def valid_parents
    project.prompts
  end

  def arguments
    prompt_sections.collect(&:arguments).flatten
  end

  def model_choices
    project.team.available_models
  end

  def compiled_prompt(args, preview: false)
    result = {
      system: [],
      user: []
    }

    system_prompt_sections.each do |section|
      result[:system] << compile_section(section, args, preview: preview)
    end

    user_prompt_sections.each do |section|
      result[:user] << compile_section(section, args, preview: preview)
    end

    {
      system: result[:system].join("\n\n"),
      user: result[:user].join("\n\n")
    }
  end

  def compile_section(section, args, preview: false)
    content = section.contents
    section.arguments.each do |argument|
      next unless args[argument.to_sym]

      inputs = InputItem.where(id: args[argument.to_sym].collect(&:to_i))
      inputs_as_string = inputs.collect { |input| input.as_string(preview: preview) }.join("\n\n")
      content = content.gsub("{{#{argument}}}", inputs_as_string)
    end
    content
  end

  def editable?
    prompt_executions.empty?
  end

  def metric_string
    "#{prompt_executions.count} (#{prompt_executions.collect { |execution| execution.outputs.count }.sum})"
  end

  def system_prompt_sections
    prompt_sections.where(system_prompt: true)
  end

  def user_prompt_sections
    prompt_sections.where(system_prompt: false)
  end
  # 🚅 add methods above.
end
