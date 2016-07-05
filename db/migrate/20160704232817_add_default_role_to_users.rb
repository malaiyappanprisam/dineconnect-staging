class AddDefaultRoleToUsers < ActiveRecord::Migration
  def up
    change_column_default(:users, :role, 0)

    User.where(role: nil).update_all(role: 0)
  end

  def down
  end
end
