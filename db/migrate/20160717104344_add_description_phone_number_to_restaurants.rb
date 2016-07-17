class AddDescriptionPhoneNumberToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :description, :text
    add_column :restaurants, :phone_number, :string
  end
end
