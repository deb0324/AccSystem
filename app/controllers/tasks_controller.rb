class TasksController < ApplicationController

  before_action :require_user, only:[:check, :new, :create]
  def check
    @task = Task.find(params[:id])
    @type = params[:type]
    check = @task.checks.where(type: params[:type]).first
    check.flag = params[:flag]

    if check.save
      redirect_to session_path(current_user, year: @task.year, type: @task.type)
    end
  end

  def index

  end

  def new
    @task = Task.new
    @year_options = ['105', '106', '107', '108', '109', '110']
  end

  def create
    year = params[:task][:year].to_i
    task_types = ["VatJan", "VatMar", "VatMay", "VatJul", "VatSep", "VatNov", "Voucher", "IncomeTax"]
    task_checks = ["Primary", "Secondary", "Recieved", "Upload"]
    @customers = Customer.all

    @customers.each do |customer|
      if customer.tasks.where(year: year).length == 0
        add_tasks(customer, year)
      end
      customer.save!
    end

    redirect_to users_path
  end

  private

  def add_tasks(customer, year)
    task_types = ["VatJan", "VatMar", "VatMay", "VatJul", "VatSep", "VatNov", "Voucher", "IncomeTax"]
    task_checks = ["Primary", "Secondary", "Recieved", "Upload"]

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