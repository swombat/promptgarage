class CreateOutputs < ActiveRecord::Migration[7.1]
  def change
    create_table :outputs do |t|
      t.references :prompt_execution, null: false, foreign_key: true
      t.string :label
      t.text :results
      t.integer :input_tokens
      t.integer :output_tokens
      t.string :message_id_api
      t.integer :user_rating

      t.timestamps
    end
  end
end
