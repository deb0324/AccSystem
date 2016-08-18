class UsersController < ApplicationController

  before_action :require_accountant, only:[:index, :new, :create, :edit, :update, :destroy]
  def index

  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_path
  end

  private 

  def user_params
    params.require(:user).permit(:code, :name, :password)
  end

  
end