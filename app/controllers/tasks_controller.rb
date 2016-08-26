class TasksController < ApplicationController

  before_action :require_user, only:[:check, :new, :create, :edit, :update]
  def check
    @task = Task.find(params[:id])
    @type = params[:type]
    check = @task.checks.where(type: params[:type]).first
    check.flag = params[:flag]

    if check.save
      redirect_to session_path(current_user, year: @task.year, type: @task.type)
    end
  end

  def new
    @task = Task.new
    @year_options = get_years
  end

  def create
    year = params[:task][:year].to_i
    @customers = Customer.all

    @customers.each do |customer|
      if customer.tasks.where(year: year).length == 0
        add_tasks(customer, year)
      end
      customer.save!
    end

    redirect_to users_path
  end

  def edit
    @task = Task.find(params[:id])
    
  end

  def update
    @task = Task.find(params[:id])
    @task.note = params[:task][:note]

    if @task.save
      redirect_to session[:session_url]
    else
      render :edit
    end
  end

  private

  def add_tasks(customer, year)
    task_types = get_task_types_eng()
    task_checks = get_check_types()
    
    task_types.each do |type|
      
      task = Task.create(year: year, type: type)
      customer.tasks << task

      task_checks.each do |check|
        task.checks << Check.create(flag: false, type: check)
      end

      #extra field for 結算申報
      if type == "IncomeTax"
        task.checks << Check.create(flag: false, type: "Accountant")
      end

      task.save!

    end
  end
end