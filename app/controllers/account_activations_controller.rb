class AccountActivationsController < ApplicationController
  before_action :find_user_by_email, only: %i(edit)

  def edit
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute activated: true, activated_at: Time.zone.now
      do_while_success @user
    else
      do_while_fail
    end
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "users.user_not_found"
  end

  def do_while_success user
    login user
    flash[:success] = t "mailers.acc_activated"
    redirect_to user
  end

  def do_while_fail
    flash[:danger] = t "mailers.invalid_link"
    redirect_to root_url
  end
end
