class Facility < ActiveRecord::Base
  default_scope { order(name: :asc) }

  has_and_belongs_to_many :restaurants

  validates :name, presence: true
end
