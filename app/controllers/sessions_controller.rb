class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      do_activate_condition user
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def handle_invalid_login
    flash.now[:danger] = t "sessions.invalid_login"
    render :new
  end

  def do_activate_condition user
    if user.activated?
      log_in user
      if params[:session][:remember_me] == Settings.session.remember
        remember user
      else
        forget user
      end
      redirect_back_or user
    else
      flash[:warning] = t "mailers.message"
      redirect_to root_url
    end
  end
end
