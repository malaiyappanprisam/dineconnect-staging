class Api::ProfileController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def detail
    @user = current_user
    if @user.update(user_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors }.to_json, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username,
                                 :gender, :date_of_birth, :profession,
                                 :nationality, :residence_status,
                                 :interested_to_meet, :payment_preference,
                                 :location, :about_me)
  end

  def current_user
    @current_user
  end
end
