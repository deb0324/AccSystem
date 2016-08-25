class SessionsController < ApplicationController

  before_action :require_user, only:[:show, :destroy]
  

  def new
    @type_options = ['1~2月營業稅','3~4月營業稅','5~6月營業稅','7~8月營業稅','9~10月營業稅','11~12月營業稅','扣繳憑單申報', '結算申報']
    @year_options = ['105', '106', '107', '108', '109', '110']
    @names = name_array()
  end

  def create

    @user = User.find_by_name(params[:session][:name].split(" ")[1])

    type = task_c2e(params[:session][:type])
    year = params[:session][:year].to_i

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to session_path(@user, year: year, type: type)
    else
      flash[:error] = "請確定資料都正確(姓名,密碼)"
      redirect_to new_session_path
    end
  end

  def show
    @user = User.find(params[:id])
    @year = params[:year]
    @query = "#{@user.name} > #{params[:year]}年 > #{task_e2c(params[:type])}"
    @raw_type = params[:type] 
    @tasks = []

    session[:testing] = request.original_url
    
    # If user is accountant, display all tasks, else display only involved tasks
    if current_user.accountant?
      customers = Customer.where(status: "current")
      customers.each do |customer|
        @tasks.concat(customer.tasks.where(year: params[:year], type: params[:type]))
      end
     
    else
      customers = is_responsible(params[:id])
      @tasks = []
      customers.each do |customer|
        @tasks.concat(customer.tasks.where(year: params[:year], type: params[:type]))
      end
    end

    # if !(params[:flag])
    #  @tasks = @tasks.sort_by{|x| x.total_checks}.reverse
    # end

  end

  def destroy
    session[:user_id] = nil

    flash[:success] = '已登出'
    redirect_to root_path
  end

  private

  # Get all the customers that the user is involved in
  def is_responsible(id)
    Customer.where(officer_id: id, status: "current") + Customer.where(manager_id: id, status: "current") + Customer.where(leader_id: id, status: "current")
  end

  # Convert task name from Chin to Eng
  def task_c2e(task)

    case task
    when '1~2月營業稅'
      'VatJan'
    when '3~4月營業稅'
      'VatMar'
    when '5~6月營業稅'
      'VatMay'
    when '7~8月營業稅'
      'VatJul'
    when '9~10月營業稅'
      'VatSep'
    when '11~12月營業稅'
      'VatNov'
    when '扣繳憑單申報'
      'Voucher'
    when '結算申報'
      'IncomeTax'
    else
      redirect_to '/'
    end  
  end

  # Convert task name from Eng to Chin
  def task_e2c(task)

    case task
    when 'VatJan'
      '1~2月營業稅'
    when 'VatMar'
      '3~4月營業稅'
    when 'VatMay'
      '5~6月營業稅'
    when 'VatJul'
      '7~8月營業稅'
    when 'VatSep'
      '9~10月營業稅'
    when 'VatNov'
      '11~12月營業稅'
    when 'Voucher'
      '扣繳憑單申報'
    when 'IncomeTax'
      '結算申報'
    else
      '###'
    end
  end
end