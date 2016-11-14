class CreateRestaurantBatches < ActiveRecord::Migration
  def change
    create_table :restaurant_batches do |t|
      t.string :latlong
      t.integer :radius
      t.boolean :finished, default: false, null: false

      t.timestamps null: false
    end
  end
end
