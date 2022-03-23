module Authentication
  extend ActiveSupport::Concern
  
  included do
    before_action :authenticate
  end

  private
  def authenticate
    if current_user = User.find_by(id: session[:user_id])
      Current.user = current_user
    else
      redirect_to signin_path, alert: 'Du behöver vara inloggad.'
    end
  end
end