class SessionsController < ApplicationController
  layout "auth"

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == 1 ? remember(user) : forget(user)
      redirect_to root_path
    else
      flash.now[:warning] = t("controller.session.create.invalid_login_warning")
      render "new"
    end
  end
end
