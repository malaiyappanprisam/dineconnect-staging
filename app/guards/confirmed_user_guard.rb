class ConfirmedUserGuard < Clearance::SignInGuard
  def call
    if user_confirmed?
      next_guard
    else
      failure "Please confirm your email"
    end
  end

  def user_confirmed?
    signed_in? && (current_user.email_confirmed_at.present? || current_user.admin?)
  end
end
