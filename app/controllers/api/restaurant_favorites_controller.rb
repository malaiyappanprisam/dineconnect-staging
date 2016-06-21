class Api::RestaurantFavoritesController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.liked_by current_user
    if @restaurant.vote_registered?
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.disliked_by current_user
    render nothing: true, status: :ok
  end
end
