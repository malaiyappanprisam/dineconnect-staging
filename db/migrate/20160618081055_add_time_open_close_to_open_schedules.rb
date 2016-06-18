class AddTimeOpenCloseToOpenSchedules < ActiveRecord::Migration
  def change
    add_column :open_schedules, :time_open, :time
    add_column :open_schedules, :time_close, :time
  end
end
