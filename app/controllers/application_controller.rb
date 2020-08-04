class ApplicationController < ActionController::Base
  include SessionsHelper

  def home
    redirect_to login_url unless logged_in?
  end
end
