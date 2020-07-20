class Admin::UsersController < Admin::ApplicationController
  include Admin::ApplicationHelper

  # before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :get_user, except: [:index, :new, :create]
  before_action :extract_params

  def show; end

  def index
    @users = User.find_by_user_name(params[:search]).paginate(page: @page, per_page: @per_page)
    flash.now[:danger] = t("controller.admin.user.index.no_user_found_warning") if params[:search].present? && !params[:search].empty? && @users.count == 0
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: {success: t("controller.admin.user.index.delete_user_success")}
    else
      flash[:danger] = t("controller.admin.user.index.delete_user_fail")
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User was created successfully!"
      redirect_to admin_users_path
    else
      render "new"
    end
  end

  def edit; end

  def update
    params = user_params.except(:password, :password_confirmation)
    params[:role] = params[:role].to_i
    if @user.update(params)
      flash[:success] = t("controller.admin.user.edit.update_user_success")
      redirect_to admin_users_path
    else
      render "edit"
    end
  end
  private
  def get_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      flash[:danger] = t("controller.admin.user.index.invalid_user_warning")
      redirect_to admin_users_path
    end
  end

  def extract_params
    @page = params[:page].present? && is_numeric?(params[:page]) ? params[:page] : Settings.controller.admin.user.default_page
    @per_page = params[:per_page].present? && is_numeric?(params[:per_page]) ? @per_page : Settings.controller.admin.user.default_per_page
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :phone_number, :department, :role)
  end
end