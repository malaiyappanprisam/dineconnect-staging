class FacilitiesController < ApplicationController
  before_action :require_login

  def index
    @facilities = Facility.page(params[:page])
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.new(facility_params)
    if @facility.save
      redirect_to facilities_path, info: "Success"
    else
      render :new
    end
  end

  def show
    @facility = Facility.find(params[:id])
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update(facility_params)
      redirect_to facilities_path, info: "Success"
    else
      render :edit
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy
    redirect_to facilities_path, info: "Success"
  end

  private
  def facility_params
    params.require(:facility).permit(:name)
  end
end
