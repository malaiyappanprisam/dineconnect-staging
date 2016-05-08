class Api::RecommendedRestaurantsController < ApiController
  def index
    @restaurants = Restaurant.order(id: :desc)
  end
end
