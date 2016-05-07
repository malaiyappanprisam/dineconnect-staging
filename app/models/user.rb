class User < ActiveRecord::Base
  include Clearance::User

  enum gender: [:male, :female]
end
