class CreateFoodTypes < ActiveRecord::Migration
  def change
    create_table :food_types do |t|
      t.integer :restaurant_id, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end
