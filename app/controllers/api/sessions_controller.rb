class Api::SessionsController < ApiController 
  include Clearance::Authentication

  def create
    if User.authenticate(session_params[:email], session_params[:password])
      render nothing: true
    else
      render nothing: true, status: :unauthorized
    end
  end

  private
  def session_params
    logger.debug(params)
    params.require(:session).permit(:email, :password)
  end

end
