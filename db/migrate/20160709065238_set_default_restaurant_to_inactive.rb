class SetDefaultRestaurantToInactive < ActiveRecord::Migration
  def change
    change_column :restaurants, :active, :boolean, null: false, default: false
  end
end
