class Api::ExploreController < ApiController

  def people
    @users = User.order(id: :desc)
  end

  def nearby
    @users = User.order(id: :desc)
    @restaurants = Restaurant.order(id: :desc)
  end

  def places
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = User.limit(20).order(id: :asc)
  end
end
