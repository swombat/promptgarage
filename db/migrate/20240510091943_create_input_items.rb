class CreateInputItems < ActiveRecord::Migration[7.1]
  def change
    create_table :input_items do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.references :type, null: true, foreign_key: {to_table: "input_types"}
      t.text :contents

      t.timestamps
    end
  end
end
