class Api::ExploreController < ApiController
  before_action :authenticate_token!

  def people
    @users = current_user.explore_people(explore_people_params)
  end

  def nearby
    @restaurants = Restaurant
    if params[:lat].present? && params[:long].present?
      @restaurants = @restaurants.nearby(params[:lat], params[:long], params[:distance])
      @restaurants = @restaurants.limit(20).order(id: :desc)
    else
      @restaurants = @restaurants.none
    end

    @users = current_user.explore_people
    @users.push(*User.favorited_on(@restaurants))
  end

  def places
    @restaurants = Restaurant.limit(20).order(id: :desc)
    @users = current_user.explore_people
    @users.push(*User.favorited_on(@restaurants))
  end

  private
  def explore_people_params
    {
      payment_preference: params[:payment_preference],
      interested_in: params[:interested_in],
      age_from: params[:age_from],
      age_to: params[:age_to]
    }.delete_if { |k, v| v.blank? }
  end
end
