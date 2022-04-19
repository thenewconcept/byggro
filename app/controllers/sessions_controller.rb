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

  def switch
    current_user = User.find_by(id: session[:user_id])
    user = User.find(params[:id])

    if current_user.is_manager? && !user.is_admin?
      session[:user_id] = user.id
      redirect_to root_path, alert: 'Du har bytt användare.'
    else
      redirect_to root_path, alert: 'Du måste vara inloggad för att kunna växla användare.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Utloggad.'
  end
end