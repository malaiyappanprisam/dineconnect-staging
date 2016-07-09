class Restaurant < ActiveRecord::Base
  attachment :cover

  acts_as_votable

  acts_as_taggable_on :known_fors
  validates :name, presence: true
  has_many :open_schedules, -> { order(:day) }
  has_and_belongs_to_many :food_types
  has_and_belongs_to_many :facilities
  has_many :photos, as: :photoable

  accepts_nested_attributes_for(:open_schedules)
  accepts_attachments_for :photos, attachment: :file, append: true

  before_save :delete_all_associations_when_inactive

  scope :general, -> { where(active: true) }

  scope :nearby, -> lat, long, distance = 10_000 do
    sql = <<-sql
    ST_Dwithin(restaurants.location::geography,
    ST_GeogFromText('POINT(#{long} #{lat})'), ?)
    sql

    where(sql, distance).where(active: true)
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

  def long
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").first
  end

  def lat
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").second
  end

  def self.explore_places(filter: nil,
                          food_type_ids: "",
                          facility_ids: "")
    restaurants = Restaurant.general
    if filter.present?
      restaurants = restaurants.fuzzy_search(name: filter)
    end
    if food_type_ids.present?
      food_type_ids_array = food_type_ids.split(",").map(&:to_i)
      restaurants = restaurants.joins(:food_types).where(food_types_restaurants: { food_type_id: food_type_ids_array })
    end
    if facility_ids.present?
      facility_ids_array = facility_ids.split(",").map(&:to_i)
      restaurants = restaurants.joins(:facilities).where(facilities_restaurants: { facility_id: facility_ids_array })
    end
    restaurants = restaurants.limit(20).order(id: :desc)
  end

  private
  def delete_all_associations_when_inactive
    if active_changed? && self.active == false
      food_types.destroy_all
      facilities.destroy_all
      ActsAsVotable::Vote.where(votable_id: self.id).destroy_all
    end
  end
end
