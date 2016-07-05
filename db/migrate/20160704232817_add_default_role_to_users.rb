class AddDefaultRoleToUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :role, 0)

    User.where(role: nil).update_all(role: 0)
  end
end
