class ChangeAreaToAreaIdRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :area
    add_column :restaurants, :area_id, :integer
  end
end
