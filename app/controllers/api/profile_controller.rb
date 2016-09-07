class Api::ProfileController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!, except: [:forgot_password]

  def me
    @users = [current_user].compact
  end

  def detail
    @user = current_user
    if @user.update(user_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors }.to_json, status: :unprocessable_entity
    end
  end

  def avatar
    @user = current_user
    if @user.update(avatar_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors }.to_json, status: :unprocessable_entity
    end
  end

  def forgot_password
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end
    render json: {}, status: :ok
  end

  def password
    @user = current_user
    if authenticate({ email: @user.email, password: params[:user][:current_password] })
      if @user.update_password_with_confirmation(password_params)
        render json: {}, status: :ok
      else
        render json: { errors: @user.errors.full_messages }.to_json, status: :unprocessable_entity
      end
    else
      render json: { errors: { current_password: ["is wrong"] } }.to_json, status: :unprocessable_entity
    end
  end

  def location
    if current_user.update(location_params)
      render json: {}, status: :ok
    else
      render json: { errors: @user.errors.full_messages }.to_json, status: :unprocessable_entity
    end
  end

  def deactivate
    current_user.update(active: false)
    render json: {}, status: :ok
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username,
                                 :gender, :date_of_birth, :profession,
                                 :nationality, :residence_status,
                                 :interested_to_meet, :payment_preference,
                                 :location, :about_me, :interested_in_list,
                                 :favorite_food_list, :onboard)
  end

  def avatar_params
    params.require(:user).permit(:avatar)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def location_params
    params.require(:user).permit(:latitude, :longitude, :district)
  end

  def current_user
    @current_user
  end

  def find_user_for_create
    Clearance.configuration.user_model.
      find_by_normalized_email params[:password][:email]
  end

  def deliver_email(user)
    mail = ::ClearanceMailer.change_password(user)

    if mail.respond_to?(:deliver_later)
      mail.deliver_later
    else
      mail.deliver
    end
  end

  def authenticate(parameters)
    Clearance.configuration.user_model.authenticate(
      parameters[:email], parameters[:password]
    )
  end
end
