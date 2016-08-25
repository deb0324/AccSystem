class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_year, :convert_name, :current_task, :declare_e2c
  
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

  def name_array
    names = User.all.pluck(:name)
    codes = User.all.pluck(:code)
    length = names.length
    arr = []
    (0...length).each do |i|
      arr << "#{codes[i]} #{names[i]}"
    end
    arr
  end

  def convert_name(user)
    name = "#{user.code} #{user.name}"
  end

  def save_url
    session[:my_url] = request.env["HTTP_REFERER"]
  end

  def current_task
    case Date.today.strftime("%m-%d")
    when ("03-01".."03-17")
      flag = "1~2月營業稅"
    when ("05-01".."05-15")
      flag = "3~4月營業稅"
    when ("07-01".."07-17")
      flag = "5~6月營業稅"
    when ("09-01".."09-17")
      flag = "7~8月營業稅"
    when ("11-01".."11-17")
      flag = "9~10月營業稅"
    when ("01-01".."01-15")
      flag = "11~12月營業稅"
    when ("01-16".."02-05")
      flag = "11~12月營業稅"
    when ("05-16".."06-05")
      flag = "11~12月營業稅"
    else
      flag = "1~2月營業稅"
    end
  end

  def declare_e2c(type)
    case type
    when "review"
      "書審"
    when "account"
      "查帳"
    when "visa"
      "簽證"
    else
      "書審"
    end
  end
end
