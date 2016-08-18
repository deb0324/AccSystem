class UserChoicesController < ApplicationController

  before_action :require_accountant, only:[:new, :create]
  def new
    @users = User.all.pluck(:name)
  end

  def create
    @user = User.find_by_name(params[:session][:name])

    if @user
      redirect_to edit_user_path(@user)
    else 
      render :new
    end
  end

end