class PromptSection < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :prompt
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :prompt
  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    prompt.prompt_sections
  end

  def arguments
    contents.scan(/{{(.*?)}}/).flatten
  end

  def editable?
    prompt.editable?
  end

  # 🚅 add methods above.
end
