class RestaurantBatchesController < ApplicationController
  before_action :require_login

  def new
    @restaurant_batch = RestaurantBatch.new
  end

  def create
    @restaurant_batch = RestaurantBatch.new(restaurant_batch_params)
    if @restaurant_batch.save
      merged_params = restaurant_batch_params.merge(batch_id: @restaurant_batch.id)
      FoursquareImporterJob.perform_async(merged_params)
      redirect_to restaurant_batch_path(@restaurant_batch), notice: "Please wait while the process is running in the background"
    else
      render :new
    end
  end

  def show
    @restaurant_batch = RestaurantBatch.find(params[:id])
  end

  private
  def restaurant_batch_params
    params.require(:restaurant_batch).permit(:latlong, :radius, :batch_id)
  end
end
