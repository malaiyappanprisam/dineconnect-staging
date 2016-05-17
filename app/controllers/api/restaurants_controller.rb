class Api::RestaurantsController < ApiController
  def recommended_users
    @users = User.order(id: :desc)
  end
end
