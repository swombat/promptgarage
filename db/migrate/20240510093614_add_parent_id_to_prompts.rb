class AddParentIdToPrompts < ActiveRecord::Migration[7.1]
  def change
    add_reference :prompts, :parent, null: true, foreign_key: {to_table: "prompts"}
  end
end
