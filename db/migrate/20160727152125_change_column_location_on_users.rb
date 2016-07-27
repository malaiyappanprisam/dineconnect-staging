class ChangeColumnLocationOnUsers < ActiveRecord::Migration
  def up
    remove_column :users, :location
    add_column :users, :location, :st_point, geographic: true
  end

  def down
    remove_column :users, :location
    add_column :users, :string
  end
end
