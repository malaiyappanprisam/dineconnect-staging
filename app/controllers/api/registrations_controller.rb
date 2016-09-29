class Api::RegistrationsController < ApiController

  def create
    user = User.new user_params
    user.email_confirmation_token = Clearance::Token.new

    if user.save
      UserMailer.registration_confirmation(user).deliver_later
      render nothing: true, status: :ok
    else
      render json: user.errors.to_json, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:registration).permit(:first_name, :last_name, :email,
                                         :date_of_birth, :gender, :password,
                                         :interested_to_meet, :interested_in_list,
                                         :favorite_food_list, :avatar)
  end
end
