class SetDefaultUserToInactive < ActiveRecord::Migration
  def change
    change_column :users, :active, :boolean, null: false, default: true
  end
end
