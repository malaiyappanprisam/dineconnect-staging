class Api::RestaurantsController < ApiController
  before_action :authenticate_token!

  def recommended_users
    @users = User.order(id: :desc)
  end
end
