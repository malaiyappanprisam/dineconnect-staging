class Api::RecommendedRestaurantsController < ApiController
  before_action :authenticate_token!

  def index
    @restaurants = Restaurant.order(id: :desc)
  end
end
