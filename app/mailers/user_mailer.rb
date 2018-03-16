class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation.subject
  #
  def confirmation user_id, user_confirmation_id
    @user = User.find_by_id(user_id)
    @user_confirmation = UserConfirmation.find_by_id(user_confirmation_id)

    if @user && @user_confirmation
      mail to: @user.email, subject: I18n.t('user_mailer.confirmation.subject')
    end
  end
end
