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

  def valid_parents
    [parent]
  end

  def arguments
    prompt_sections.collect(&:contents).collect { |contents| contents.scan(/{{(.*?)}}/).flatten }.flatten
  end

  def model_choices
    project.team.available_models
  end
  # 🚅 add methods above.
end
