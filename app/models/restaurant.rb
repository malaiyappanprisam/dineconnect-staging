class Restaurant < ActiveRecord::Base
  attachment :cover

  acts_as_taggable_on :known_fors
  validates :name, presence: true
  has_many :open_schedules

  accepts_nested_attributes_for(:open_schedules)
end
