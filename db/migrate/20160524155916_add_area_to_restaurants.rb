class AddAreaToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :area, :string
  end
end
