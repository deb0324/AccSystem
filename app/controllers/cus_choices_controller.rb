class CusChoicesController < ApplicationController

  before_action :require_accountant, only:[:new, :create]
  def new
    @customers = Customer.all.order(:code).pluck(:name_abrev)
  end

  def create
    @customer = Customer.find_by_name_abrev(params[:choice][:name_abrev])

    if @customer
      redirect_to edit_customer_path(@customer)
    else 
      render :new
    end
  end

end