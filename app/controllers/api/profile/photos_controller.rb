class Api::Profile::PhotosController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def create
    @user = current_user
    if @user.update(photos_params)
      render nothing: true, status: :ok
    else
      render json: { errors: @user.errors }.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    @photo = @user.photos.find(params[:id])
    if @photo.destroy
      render nothing: true, status: :ok
    else
      render json: { errors: @user.errors.full_messages }.to_json, status: :unprocessable_entity
    end
  end

  private
  def current_user
    @current_user
  end

  def photos_params
    params.require(:user).permit(photos_files: [])
  end
end
