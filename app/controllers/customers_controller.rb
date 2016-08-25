class CustomersController < ApplicationController

  before_action :require_accountant, only:[:new, :create, :edit, :update, :destroy]

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
    @users = name_array()
    @declare_types = ["書審","查帳","簽證"]

  end

  def show
    @customer = Customer.find(params[:id])
  end

  def create

    @customer = Customer.create(customer_params)
    @customer.officer = User.find_by_name(params[:customer][:officer_id].split(" ")[1])
    @customer.leader = User.find_by_name(params[:customer][:leader_id].split(" ")[1])
    @customer.manager = User.find_by_name(params[:customer][:manager_id].split(" ")[1])
    @customer.status = "current"
    @customer.start_date = params[:customer][:start_date].to_date
    @customer.declare_type = declare_c2e(params[:customer][:declare_type])

    if @customer.save
      flash[:success] = "客戶:#{@customer.name} 新增成功"
      redirect_to users_path
    else
      @users = name_array()
      @declare_types = ["書審","查帳","簽證"]
      render :new
    end
  end

  def edit
    @customer = Customer.find(params[:id])
    @users = name_array()
    @status = ["現有客戶", "停業", "遷出"]
    @declare_types = ["書審","查帳","簽證"]

    @curr_status = status_e2c(@customer.status)
    @declare_type = declare_e2c(@customer.declare_type)
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.officer = User.find_by_name(params[:customer][:officer_id].split(" ")[1])
    @customer.leader = User.find_by_name(params[:customer][:leader_id].split(" ")[1])
    @customer.manager = User.find_by_name(params[:customer][:manager_id].split(" ")[1])
    @customer.status = status_c2e(params[:customer][:status])
    @customer.start_date = params[:customer][:start_date].to_date
    @customer.declare_type = declare_c2e(params[:customer][:declare_type])

    if @customer.update(customer_params) && @customer.save
      flash[:success] = "客戶:#{@customer.name} 修改成功"
      redirect_to users_path
    else
      @users = name_array()
      @status = ["現有客戶", "停業", "遷出"]
      @declare_types = ["書審","查帳","簽證"]
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
    redirect_to users_path
  end

  private

  def customer_params
    params.require(:customer).permit(:code, :name_abrev, :name, :reg_addr, :contact_addr, :contact, :cellphone, :phone, :fax, :email, :fee, :note_1, :note_2)
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

  def declare_c2e(type)
    case type
    when "書審"
      "review"
    when "查帳"
      "account"
    when "簽證"
      "visa"
    else
      "review"
    end
  end

end