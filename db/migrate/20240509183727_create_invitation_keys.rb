class CreateInvitationKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :invitation_keys do |t|
      t.references :team, null: false, foreign_key: true
      t.string :key

      t.timestamps
    end
  end
end
