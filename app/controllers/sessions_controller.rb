class SessionsController < ApplicationController
  layout false

  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = 'Ogiltigt användarnamn eller lösenord.'
      render :new, turbo_stream: turbo_stream.update('flash', partial: 'shared/flash')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Utloggad.'
  end
end