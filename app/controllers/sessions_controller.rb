class SessionsController < ApplicationController
  layout false

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      flash[:notice] = 'Signed in successfully.'
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out'
  end
end