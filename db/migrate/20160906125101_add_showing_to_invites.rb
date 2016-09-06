class AddShowingToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :showing, :boolean, default: true
  end
end
