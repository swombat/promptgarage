class CreatePromptExecutions < ActiveRecord::Migration[7.1]
  def change
    create_table :prompt_executions do |t|
      t.references :prompt, null: false, foreign_key: true
      t.string :label
      t.text :compiled_parameters
      t.text :parameters_summary
      t.string :model

      t.timestamps
    end
  end
end
