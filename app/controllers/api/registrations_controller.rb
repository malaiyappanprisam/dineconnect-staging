class Api::RegistrationsController < ApiController

  def create
    user = User.new user_params
    if user.save!
      render nothing: true
    else
      render json: user.errors.to_json, status: 401
    end
  end

  private

  def user_params
    params.require(:registration).permit(:first_name, :last_name, :email, :date_of_birth, :gender, :password)
  end
end
