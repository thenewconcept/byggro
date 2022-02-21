class ApplicationController < ActionController::Base
  include Pundit
  def pundit_user
    Current.user
  end
end
