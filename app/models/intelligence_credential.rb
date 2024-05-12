class IntelligenceCredential < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :api_key, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_class_names
    AIApi.registered_subclasses
  end

  def models
    class_name.constantize.new(access_token: api_key).models
  end
  # 🚅 add methods above.
end
