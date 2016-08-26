class SessionsController < ApplicationController

  before_action :require_user, only:[:show, :destroy]
  

  def new
    @type_options = get_task_types_chin()
    @year_options = get_years()
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

    session[:session_url] = request.original_url

    # If user is accountant, display all tasks, else display only involved tasks
    if current_user.accountant?
      customers = Customer.where(status: "current")
    
    elsif current_user.moved?
      customers = Customer.where(status: "moved")

    elsif current_user.closed?
      customers = Customer.where(status: "closed") 

    else
      types = ["officer", "leader", "manager"]
      types.each do |type|
        customers = is_responsible(params[:id], type)
        @tasks = []
        customers.each do |customer|
          @tasks.concat(customer.tasks.where(year: params[:year], type: params[:type]))
        end
        case type
        when "officer"
          @officer_tasks = @tasks
        when "leader"
          @leader_tasks = @tasks
        else
          @manager_tasks = @tasks
        end
      end
    end

    if current_user.accountant? || current_user.moved? || current_user.closed?
      customers.each do |customer|
        @tasks.concat(customer.tasks.where(year: params[:year], type: params[:type]))
      end
      @tasks = @tasks.sort_by{|x| x.total_checks}
    else
      @officer_tasks = @officer_tasks.sort_by{|x| x.total_checks}
      @leader_tasks = @leader_tasks.sort_by{|x| x.total_checks}
      @manager_tasks = @manager_tasks.sort_by{|x| x.total_checks}
    end
  

  end

  def destroy
    session[:user_id] = nil

    flash[:success] = '已登出'
    redirect_to root_path
  end

  private

  # Get all the customers that the user is involved in depending on user type
  def is_responsible(id, type)
    case type
    when "officer"
      Customer.where(officer_id: id, status: "current")
    when "leader"
      Customer.where(leader_id: id, status: "current") - Customer.where(officer_id: id, status: "current")
    when "manager"
      Customer.where(manager_id: id, status: "current") - Customer.where(leader_id: id, status: "current") - Customer.where(officer_id: id, status: "current")
    else

    end
  end
end