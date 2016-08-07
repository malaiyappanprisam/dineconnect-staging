class AddInitiatorToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :initiator, :boolean
  end
end
