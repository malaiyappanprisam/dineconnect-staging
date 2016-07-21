class Api::RestaurantsController < ApiController
  before_action :authenticate_token!

  def show
    restaurant = Restaurant.general.find(params[:id])
    @restaurants = [restaurant].compact
    @users = User.favorited_on(@restaurants)
    @users.push(current_user)
    @food_types = restaurant.food_types
    @facilities = restaurant.facilities
  end

  def recommended_users
    @users = User.order(id: :desc)
  end
end
