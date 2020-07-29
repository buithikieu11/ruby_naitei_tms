include SessionsHelper

module Helpers
  def login_as_supervisor
    supervisor = FactoryBot.create(:user, role: User.roles[:supervisor])
    log_in supervisor
  end

  def login_as_trainee
    trainee = FactoryBot.create(:user, role: User.roles[:trainee])
    log_in trainee
  end
end