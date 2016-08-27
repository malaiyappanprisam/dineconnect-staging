class AddDigitOfPostalCodeToArea < ActiveRecord::Migration
  def change
    add_column :areas, :digit_of_postal_code, :string
  end
end
