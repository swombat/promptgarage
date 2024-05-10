class CreatePromptSections < ActiveRecord::Migration[7.1]
  def change
    create_table :prompt_sections do |t|
      t.references :prompt, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.text :description
      t.text :contents

      t.timestamps
    end
  end
end
