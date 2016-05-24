class Api::RecommendedRestaurantsController < ApiController
  before_action :authenticate_token!

  def index
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = User.limit(20).order(id: :asc)
  end
end
