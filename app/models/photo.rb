class Photo < ActiveRecord::Base
  belongs_to :photoable, polymorphic: true
  attachment :file
end
