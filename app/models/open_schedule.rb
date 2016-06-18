class OpenSchedule < ActiveRecord::Base
  serialize :time_open, Tod::TimeOfDay
  serialize :time_close, Tod::TimeOfDay
  belongs_to :restaurant

  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  validates :time_open, presence: true
  validates :time_close, presence: true
end
