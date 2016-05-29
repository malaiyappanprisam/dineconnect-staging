class AddCoverToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :cover_id, :string
  end
end
