class CopyHourToTimeOnOpenSchedules < ActiveRecord::Migration
  def up
    OpenSchedule.find_each do |open_schedule|
      open_schedule.time_open = "#{open_schedule.hour_open}:00"
      open_schedule.time_close = "#{open_schedule.hour_close}:00"
      open_schedule.save!
    end
  end

  def down
  end
end
