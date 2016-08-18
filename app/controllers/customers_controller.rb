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

    if @customer.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @customer = Customer.find(params[:id])
    @users = User.all.pluck(:name)
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.officer = User.find_by_name(params[:customer][:officer_id])
    @customer.leader = User.find_by_name(params[:customer][:leader_id])
    @customer.manager = User.find_by_name(params[:customer][:manager_id])

    if @customer.update(customer_params) && @customer.save
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

    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name)
  end
end