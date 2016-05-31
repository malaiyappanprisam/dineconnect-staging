class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user, index: true
      t.references :invitee, index: true
      t.string :channel

      t.timestamps null: false
    end
  end
end
