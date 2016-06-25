class Restaurant < ActiveRecord::Base
  attachment :cover

  acts_as_votable

  acts_as_taggable_on :known_fors
  validates :name, presence: true
  has_many :open_schedules, -> { order(:day) }
  has_and_belongs_to_many :food_types
  has_and_belongs_to_many :facilities

  accepts_nested_attributes_for(:open_schedules)

  scope :nearby, -> lat, long, distance = 10_000 do
    sql = <<-sql
    ST_Dwithin(restaurants.location::geography,
    ST_GeogFromText('POINT(#{long} #{lat})'), ?)
    sql

    where(sql, distance)
  end

  def location=(latlong)
    longlat = latlong.to_s.gsub(/\s+/, "").split(",").reverse.join(" ")
    self[:location] = "POINT (#{longlat})"
  end

  def location
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").reverse.join(", ")
  end

  def location_original
    self[:location].to_s
  end
end
