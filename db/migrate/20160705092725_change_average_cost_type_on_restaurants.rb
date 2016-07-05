class ChangeAverageCostTypeOnRestaurants < ActiveRecord::Migration
  def change
    change_column(:restaurants, :average_cost, :integer)
  end
end
