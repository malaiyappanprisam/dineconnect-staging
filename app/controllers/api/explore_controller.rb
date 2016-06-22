class Api::ExploreController < ApiController
  before_action :authenticate_token!

  def people
    @users = current_user.explore_people
  end

  def nearby
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = current_user.explore_people
    @users.push(*User.favorited_on(@restaurants))
  end

  def places
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = current_user.explore_people
    @users.push(*User.favorited_on(@restaurants))
  end
end
