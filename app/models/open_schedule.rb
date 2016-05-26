class OpenSchedule < ActiveRecord::Base
  belongs_to :restaurant

  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  validates :hour_open,  numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: 23 }
  validates :hour_close, numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: 23 }
  validate :hour_close_is_more_than_open

  private
  def hour_close_is_more_than_open
    unless hour_close.to_i > hour_open.to_i
      errors.add(:hour_close, "can't be less than hour open")
    end
  end
end
