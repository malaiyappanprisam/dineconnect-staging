class AddActiveToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :active, :boolean
  end
end
