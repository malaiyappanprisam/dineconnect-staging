class SetDefaultInitiatorToTrue < ActiveRecord::Migration
  def up
    change_column :invites, :initiator, :boolean, default: true

    Invite.all.each do |invite|
      invite.update!(initiator: true)
    end
  end

  def down
  end
end
