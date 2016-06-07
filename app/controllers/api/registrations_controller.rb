class Api::RegistrationsController < ApiController

  def create
    user = User.new user_params
    if user.save
      render nothing: true, status: :ok
    else
      render json: user.errors.to_json, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:registration).permit(:first_name, :last_name, :email,
                                         :date_of_birth, :gender, :password,
                                         :interested_to_meet, :avatar)
  end
end
