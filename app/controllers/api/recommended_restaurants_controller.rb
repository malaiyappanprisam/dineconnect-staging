class Api::RecommendedRestaurantsController < ApiController
  before_action :authenticate_token!

  def index
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = User.favorited_on(@restaurants)
    @users.push(current_user)
  end
end
