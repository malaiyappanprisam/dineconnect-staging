class AddUniqueToInvites < ActiveRecord::Migration
  def change
    add_index :invites, [:user_id, :invitee_id], unique: true
  end
end
