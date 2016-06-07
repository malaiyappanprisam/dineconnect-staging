class AddLocationToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :location, :st_point, geographic: true
  end
end
