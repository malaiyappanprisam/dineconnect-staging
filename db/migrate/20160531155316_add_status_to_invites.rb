class AddStatusToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :status, :integer
  end
end
