class UsersController < ApplicationController
  
  def new
    @user = User.new
    render "users/new", layout: "auth"
  end
   
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = t("app.controller.user.create")
      redirect_to root_url
    else
      render "users/new", layout: "auth"
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :email,:phone_number, :password, :password_confirmation)
  end
end
