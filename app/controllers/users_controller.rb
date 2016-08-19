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
      flash[:success] = "員工:#{@user.name} 新增成功"
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
      flash[:success] = "員工:#{@user.name} 修改成功"
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash[:success] = "員工刪除成功"
    @user.destroy

    
    redirect_to root_path
  end

  private 

  def user_params
    params.require(:user).permit(:code, :name, :password)
  end

  
end