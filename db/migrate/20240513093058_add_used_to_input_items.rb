class AddUsedToInputItems < ActiveRecord::Migration[7.1]
  def change
    add_column :input_items, :used, :boolean, default: false
  end
end
