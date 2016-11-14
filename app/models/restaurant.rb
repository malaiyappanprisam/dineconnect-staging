class Restaurant < ActiveRecord::Base
  attachment :cover

  acts_as_votable

  acts_as_taggable_on :known_fors
  validates :name, presence: true
  has_many :open_schedules, -> { order(:day).order(:time_open) }

  has_and_belongs_to_many :food_types
  has_and_belongs_to_many :facilities
  has_many :photos, as: :photoable
  belongs_to :area

  accepts_nested_attributes_for(:open_schedules, reject_if: :reject_open_schedules)
  accepts_attachments_for :photos, attachment: :file, append: true

  enum price: [
    :"0_10", :"10_20", :"20_30", :"30_40", :"40_50", :"50_75",
    :"75_100", :"100_150", :"150_200", :"200_above"
  ]

  before_save :delete_all_associations_when_inactive

  def reject_open_schedules(attributes)
    attributes["time_open"].blank? &&
      attributes["time_close"].blank?
  end

  scope :general, -> { where(active: true) }

  scope :nearby, -> lat, long, distance = 10_000 do
    sql_select = <<-sql_select
    restaurants.*,
    ST_Distance(ST_GeogFromText('POINT(#{long} #{lat})'), restaurants.location) AS distance
    sql_select
    sql = <<-sql
    ST_Dwithin(restaurants.location::geography,
    ST_GeogFromText('POINT(#{long} #{lat})'), ?)
    sql

    select(sql_select).where(sql, distance).where(active: true).order('distance')
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
    food_type_restaurants = Restaurant.none
    if filter.present?
      restaurants = restaurants.fuzzy_search(name: filter)
      food_type_ids_array = FoodType.fuzzy_search(name: filter).map(&:id)
      food_type_restaurants = Restaurant.general.joins(:food_types).where(food_types_restaurants: { food_type_id: food_type_ids_array })
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
    restaurants.concat(food_type_restaurants)
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
