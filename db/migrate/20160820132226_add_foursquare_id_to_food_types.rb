class AddFoursquareIdToFoodTypes < ActiveRecord::Migration
  def change
    add_column :food_types, :foursquare_id, :string
  end
end
