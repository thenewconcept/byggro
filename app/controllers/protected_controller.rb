class ProtectedController < ApplicationController
  before_action  :set_current_user, :require_login!

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login!
    redirect_to signin_path, alert: 'You must be signed in' if Current.user.nil?
  end
end