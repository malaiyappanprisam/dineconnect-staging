class Api::ExploreController < ApiController
  before_action :authenticate_token!

  def people
    @users = current_user.explore_people(explore_people_params)
  end

  def nearby
    @restaurants = Restaurant.general
    @users = User.general
    if params[:lat].present? && params[:long].present?
      @restaurants = @restaurants.nearby(params[:lat], params[:long], params[:distance])
      @users = @users.nearby(params[:lat], params[:long], params[:distance])
    else
      @restaurants = @restaurants.none
      @users = @users.none
    end
    @restaurants = @restaurants.limit(20).order(id: :desc)

    @users.push(*User.favorited_on(@restaurants))
  end

  def places
    @restaurants = Restaurant.explore_places(explore_places_params)
    @users = User.favorited_on(@restaurants)
  end

  def places_options
    @food_types = FoodType.none
    @facilities = Facility.all
  end

  private
  def explore_people_params
    {
      payment_preference: params[:payment_preference],
      interested_in: params[:interested_in],
      age_from: params[:age_from],
      age_to: params[:age_to],
      interest: params[:interest]
    }.delete_if { |k, v| v.blank? }
  end

  def explore_places_params
    {
      filter: params[:filter],
      food_type_ids: params[:food_type_ids],
      facility_ids: params[:facility_ids]
    }.delete_if { |k, v| v.blank? }
  end
end
