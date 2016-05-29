class RestaurantsController < ApplicationController
  before_action :require_login

  def index
    @restaurants = Restaurant.page(params[:page])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path, info: "Success"
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
      redirect_to restaurants_path, info: "Success"
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
                                       :known_for_list, :cover)
  end
end
