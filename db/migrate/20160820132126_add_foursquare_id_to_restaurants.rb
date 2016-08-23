class AddFoursquareIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :foursquare_id, :string
  end
end
