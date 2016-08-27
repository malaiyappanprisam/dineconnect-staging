class AreasController < ApplicationController
  before_action :require_login

  def index
    @areas = Area.page(params[:page])
    authorize @areas
  end

  def new
    @area = Area.new
    authorize @area
  end

  def create
    @area = Area.new(area_params)
    authorize @area
    if @area.save
      redirect_to areas_path, info: "Success"
    else
      render :new
    end
  end

  def show
    @area = Area.find(params[:id])
    authorize @area
  end

  def edit
    @area = Area.find(params[:id])
    authorize @area
  end

  def update
    @area = Area.find(params[:id])
    authorize @area
    if @area.update(area_params)
      redirect_to areas_path, info: "Success"
    else
      render :edit
    end
  end

  def destroy
    @area = Area.find(params[:id])
    authorize @area
    @area.destroy
    redirect_to areas_path, info: "Success"
  end

  private
  def area_params
    params.require(:area).permit(:name, :digit_of_postal_code)
  end
end

