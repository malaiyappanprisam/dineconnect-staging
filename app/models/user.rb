class User < ActiveRecord::Base
  include Clearance::User

  enum gender: [:male, :female]

  def age
    if date_of_birth
      ((Date.today - date_of_birth) / 365).to_i
    else
      0
    end
  end
end
