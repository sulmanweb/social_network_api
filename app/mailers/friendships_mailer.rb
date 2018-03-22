class FriendshipsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.friendships_mailer.requested.subject
  #
  def requested user_id, requester_id
    @user = User.find user_id
    @requester = User.find requester_id

    mail to: @user.email, subject: I18n.t('friendships_mailer.requested.subject')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.friendships_mailer.accepted.subject
  #
  def accepted user_id, accepter_id
    @user = User.find user_id
    @accepter = User.find accepter_id

    mail to: @user.email, subject: I18n.t('friendships_mailer.accepted.subject')
  end
end
