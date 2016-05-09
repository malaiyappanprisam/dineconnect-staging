class Api::SessionsController < ApiController 
  include Clearance::Authentication

  def create
    @user = User.authenticate(session_params[:email], session_params[:password])
    if @user
      @token = @user.access_token(params[:device_id])
      @token = @user.generate_access_token(params[:device_id]) unless @token
      @user.save!
      render template: 'api/sessions/user'
    else
      render nothing: true, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
