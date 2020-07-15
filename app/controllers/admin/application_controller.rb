class Admin::ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :require_admin

  def home; end

  private
  def require_admin
    unless current_user&.supervisor?
      redirect_to root_path, flash: {danger: t("controller.admin.application.access_denied")}
    end
  end
end
