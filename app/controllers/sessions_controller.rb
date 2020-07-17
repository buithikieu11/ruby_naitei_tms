class SessionsController < ApplicationController
  layout "auth"

  before_action :restrict_logged_in_user

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to root_path
    else
      flash.now[:danger] = t("controller.session.create.invalid_login_warning")
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def restrict_logged_in_user
    redirect_to root_url unless current_user.nil?
  end
end
