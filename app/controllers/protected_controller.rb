class ProtectedController < ApplicationController
  include Authentication
  include Pundit
  
  def pundit_user
    Current.user
  end
end