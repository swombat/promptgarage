class InputItem < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :project
  belongs_to :type, class_name: "InputType", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :project
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :type, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_types
    project.input_types
  end

  def as_string(preview: false, expanded_tags: true)
    if preview
      expanded_tags ? "[{[{#{name} (#{type.name})}]}]" : "{{#{name} (#{type.name})}}"
    else
      "<#{type.name.gsub(' ', '')}>#{contents}</#{type.name.gsub(' ', '')}>"
    end
  end
  # 🚅 add methods above.
end
