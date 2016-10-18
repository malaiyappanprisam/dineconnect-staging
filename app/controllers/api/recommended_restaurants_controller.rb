class Api::RecommendedRestaurantsController < ApiController
  before_action :authenticate_token!

  def index
    @restaurants = current_user.recommended_restaurants.limit(20).order(id: :desc)
    if @restaurants.empty?
      @restaurants = Restaurant.general.limit(20).order(id: :desc)
    end
    @users = User.favorited_on(@restaurants)
    @users.push(current_user)
    @food_types = @restaurants.flat_map do |restaurant|
      restaurant.food_types
    end
  end
end
