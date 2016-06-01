class AddDefaultStatusToInvites < ActiveRecord::Migration
  def change
    change_column_default(:invites, :status, 0)
  end
end
