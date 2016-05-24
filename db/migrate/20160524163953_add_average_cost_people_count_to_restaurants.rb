class AddAverageCostPeopleCountToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :people_count, :integer
    add_column :restaurants, :average_cost, :decimal
  end
end
