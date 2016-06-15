class Api::UsersController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def show
    @users = [User.find(params[:id])]
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors }.to_json, status: :unprocessable_entity
    end
  end

  def recommended_restaurants
    @restaurants = Restaurant.order(id: :desc)
    @users = User.limit(20).order(id: :asc)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username,
                                 :gender, :date_of_birth, :profession,
                                 :nationality, :residence_status,
                                 :interested_to_meet, :payment_preference,
                                 :location, :about_me)
  end
end
