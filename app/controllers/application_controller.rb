class ApplicationController < ActionController::Base
  include Pundit::Authorization
  def pundit_user
    Current.user
  end
end
