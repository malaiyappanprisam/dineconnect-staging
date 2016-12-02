class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_last_seen_at, if: proc {current_user.present?}

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def set_last_seen_at
    if current_user
      current_user.touch :last_seen_at
    end
  end
end
