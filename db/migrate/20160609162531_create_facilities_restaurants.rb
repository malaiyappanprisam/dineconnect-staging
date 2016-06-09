class CreateFacilitiesRestaurants < ActiveRecord::Migration
  def change
    create_table :facilities_restaurants do |t|
      t.references :facility, index: true
      t.references :restaurant, index: true
    end
  end
end
