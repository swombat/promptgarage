class CreateIntelligenceCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :intelligence_credentials do |t|
      t.references :team, null: false, foreign_key: true
      t.string :api_key
      t.string :class_name

      t.timestamps
    end
  end
end
