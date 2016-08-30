class CusChoicesController < ApplicationController

  before_action :require_accountant, only:[:new, :create]
  def new
    @customers = cus_array()
  end

  def create
    @customer = Customer.find_by_name_abrev(params[:choice][:name].split(" ")[1])

    if @customer
      redirect_to edit_customer_path(@customer)
    else 
      render :new
    end
  end

end