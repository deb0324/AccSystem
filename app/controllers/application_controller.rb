class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_year
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to login_path unless current_user
  end

  def require_accountant
    redirect_to login_path unless current_user && current_user.accountant? 
  end

  # Calculate 民國 year
  def current_year
    Date.today.strftime("%Y").to_i - 1911
  end
end
