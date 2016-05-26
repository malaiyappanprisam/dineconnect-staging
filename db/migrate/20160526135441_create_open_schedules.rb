class CreateOpenSchedules < ActiveRecord::Migration
  def change
    create_table :open_schedules do |t|
      t.integer :restaurant_id, index: true
      t.integer :day
      t.integer :hour_open
      t.integer :hour_close

      t.timestamps null: false
    end
  end
end
