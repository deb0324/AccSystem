class CustomersController < ApplicationController

  before_action :require_accountant, only:[:new, :create, :edit, :update, :destroy]

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
    @users = User.all.pluck(:name)
  end

  def create
    @customer = Customer.create(customer_params)
    @customer.officer = User.find_by_name(params[:customer][:officer_id])
    @customer.leader = User.find_by_name(params[:customer][:leader_id])
    @customer.manager = User.find_by_name(params[:customer][:manager_id])
    @customer.status = "current"

    if @customer.save
      flash[:success] = "客戶:#{@customer.name} 新增成功"
      redirect_to root_path
    else
      redirect_to new_customer_path
    end
  end

  def edit
    @customer = Customer.find(params[:id])
    @users = User.all.pluck(:name)
    @status = ["現有客戶", "停業", "遷出"]
    @curr_status = status_e2c(@customer.status)
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.officer = User.find_by_name(params[:customer][:officer_id])
    @customer.leader = User.find_by_name(params[:customer][:leader_id])
    @customer.manager = User.find_by_name(params[:customer][:manager_id])
    @customer.status = status_c2e(params[:customer][:status])

    if @customer.update(customer_params) && @customer.save
      flash[:success] = "客戶:#{@customer.name} 修改成功"
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @customer = Customer.find(params[:id])

    tasks = @customer.tasks
    tasks.each do |task|
      task.checks.destroy_all
    end
    
    tasks.destroy_all
    @customer.destroy

    flash[:success] = "客戶刪除成功"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name)
  end

  def status_c2e(status)
    case status
    when "現有客戶"
      "current"
    when "停業"
      "closed"
    when "遷出"
      "moved"
    else
      "current"
    end
  end

  def status_e2c(status)
    case status
    when "current"
      "現有客戶"
    when "closed"
      "停業"
    when "moved"
      "遷出"
    else
      "現有客戶"
    end
  end
end