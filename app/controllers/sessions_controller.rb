class SessionsController < Clearance::SessionsController
  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success? && @user.admin?
        redirect_back_or url_after_create
      elsif status.success?
        sign_out
        flash.now.notice = "Can't login"
        render template: "sessions/new", status: :unauthorized
      else
        flash.now.notice = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end
end
