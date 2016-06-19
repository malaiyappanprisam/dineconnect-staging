class RestaurantsController < ApplicationController
  before_action :require_login

  def index
    @restaurants = Restaurant.order(updated_at: :desc).page(params[:page])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant), info: "Success"
    else
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant), info: "Success"
    else
      render :edit
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path, info: "Success"
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :area,
                                       :average_cost, :people_count,
                                       :known_for_list, :cover,
                                       :location, food_type_ids: [],
                                       facility_ids: [],
                                       open_schedules_attributes: [
                                         :id, :day, :hour_open,
                                         :hour_close, :time_open,
                                         :time_close, :_destroy
                                       ])
  end
end
