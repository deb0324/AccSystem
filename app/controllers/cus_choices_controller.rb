class CusChoicesController < ApplicationController

  before_action :require_accountant, only:[:new, :create]
  def new
    @customers = Customer.all.pluck(:name)
  end

  def create
    @customer = Customer.find_by_name(params[:choice][:name])

    if @customer
      redirect_to edit_customer_path(@customer)
    else 
      render :new
    end
  end

end