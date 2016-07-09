class Api::RestaurantFavoritesController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def create
    @restaurant = Restaurant.general.find(params[:restaurant_id])
    if current_user.voted_for? @restaurant
      @restaurant.unliked_by current_user
    else
      @restaurant.liked_by current_user
    end
    render nothing: true, status: :ok
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.unliked_by current_user
    render nothing: true, status: :ok
  end
end
