class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

  # Expose these methods to the views
  helper_method :current_user, :logged_in?

  private
  def current_user
    @current_user ||= User.find_by(session_token: session[:token])
  end

  def logged_in?
    !!current_user
  end

  def log_in(user)
    @current_user = user
    session[:token] = user.reset_session_token!
  end

  def log_out
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

  def ensure_signed_in!
    redirect_to new_session_url unless signed_in?
  end

  def ensure_signed_out!
    redirect_to subs_url if signed_in?
  end
end
