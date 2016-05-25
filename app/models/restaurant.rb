class Restaurant < ActiveRecord::Base
  acts_as_taggable_on :known_fors
  validates :name, presence: true
end
