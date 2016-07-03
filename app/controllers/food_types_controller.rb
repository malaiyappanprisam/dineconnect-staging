class FoodTypesController < ApplicationController
  before_action :require_login

  def index
    @food_types = FoodType.page(params[:page])
    authorize @food_types
  end

  def new
    @food_type = FoodType.new
    authorize @food_type
  end

  def create
    @food_type = FoodType.new(food_type_params)
    authorize @food_type
    if @food_type.save
      redirect_to food_types_path, info: "Success"
    else
      render :new
    end
  end

  def show
    @food_type = FoodType.find(params[:id])
    authorize @food_type
  end

  def edit
    @food_type = FoodType.find(params[:id])
    authorize @food_type
  end

  def update
    @food_type = FoodType.find(params[:id])
    authorize @food_type
    if @food_type.update(food_type_params)
      redirect_to food_types_path, info: "Success"
    else
      render :edit
    end
  end

  def destroy
    @food_type = FoodType.find(params[:id])
    authorize @food_type
    @food_type.destroy
    redirect_to food_types_path, info: "Success"
  end

  private
  def food_type_params
    params.require(:food_type).permit(:name)
  end
end
