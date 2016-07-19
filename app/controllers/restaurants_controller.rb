class RestaurantsController < ApplicationController
  before_action :require_login

  def index
    @restaurants = Restaurant
    if params[:search].present?
      @restaurants = @restaurants.fuzzy_search(params[:search])
    end
    @q = @restaurants.ransack(params[:q])
    @restaurants = @q.result(distinct: true)
    @restaurants = @restaurants.order(created_at: :desc).page(params[:page])
    authorize @restaurants
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    authorize @restaurant
    if @restaurant.save
      redirect_to restaurant_path(@restaurant), info: "Success"
    else
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant), info: "Success"
    else
      render :edit
    end
  end


  def activate
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    @restaurant.update(active: true)
    redirect_to restaurants_path, info: "Restaurant activated"
  end

  def deactivate
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    @restaurant.update(active: false)
    redirect_to restaurants_path, info: "Restaurant deactivated"
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
    @restaurant.destroy
    redirect_to restaurants_path, info: "Success"
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :area_id,
                                       :average_cost, :people_count, :price,
                                       :known_for_list, :cover,
                                       :location, :description,
                                       :phone_number, food_type_ids: [],
                                       facility_ids: [], photos_files: [],
                                       open_schedules_attributes: [
                                         :id, :day, :hour_open,
                                         :hour_close, :time_open,
                                         :time_close, :_destroy
                                       ])
  end
end
