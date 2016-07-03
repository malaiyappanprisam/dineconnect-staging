class PhotosController < ApplicationController
  before_action :require_login

  def destroy
    restaurant = Restaurant.find(params[:restaurant_id])
    photo = restaurant.photos.find(params[:id])
    authorize photo
    photo.destroy
    redirect_to restaurant_path(restaurant), info: "Success"
  end
end
