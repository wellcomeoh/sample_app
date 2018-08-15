class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.acc_activation")
  end

  def password_reset
    @user = user
    mail to: user.email, subject: t ("password_resets.password_reset")
  end
end
