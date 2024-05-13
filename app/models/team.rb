class Team < ApplicationRecord
  include Teams::Base
  include Webhooks::Outgoing::TeamSupport
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  has_many :invitation_keys, dependent: :destroy, enable_cable_ready_updates: true
  has_many :intelligence_credentials, dependent: :destroy, enable_cable_ready_updates: true
  has_many :projects, dependent: :destroy, enable_cable_ready_updates: true
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def available_models
    intelligence_credentials.collect { |credential| credential.models }.flatten
  end

  def api_for(model)
    credential = intelligence_credentials.select { |credential| credential.models.include?(model) }.first
    credential.class_name.constantize.new(access_token: credential.api_key)
  end
  # 🚅 add methods above.
end
