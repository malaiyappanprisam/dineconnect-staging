class Api::ExploreController < ApiController
  before_action :authenticate_token!

  def people
    @users = current_user.explore_people
  end

  def nearby
    @users = current_user.explore_people
    @restaurants = Restaurant.order(id: :desc)
  end

  def places
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = current_user.explore_people
  end
end
