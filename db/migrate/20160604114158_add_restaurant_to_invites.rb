class AddRestaurantToInvites < ActiveRecord::Migration
  def change
    add_reference :invites, :restaurant, index: true, foreign_key: true
  end
end
