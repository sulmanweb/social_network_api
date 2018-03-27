class V1::Auth::PasswordsController < ApplicationController
  before_action :authenticate_user, only: %i[change_password]

  # create forget password request
  def create
    return render status: :unprocessable_entity, json: {errors: [I18n.t('errors.insufficient_params')]} unless params[:email]
    user = User.find_by_email(params[:email])
    unless user.nil?
      user_confirmation = UserConfirmation.create(c_type: :reset_password, user: user)
      # send mail to reset password
      UserMailer.reset_password(user.id, user_confirmation.id).deliver_later
    end
    render status: :created, json: {message: I18n.t('messages.forget_request_sent')}
  end

  # accepting change password request
  def update
    return render status: :unprocessable_entity, json: {errors: [I18n.t('errors.insufficient_params')]} unless params[:token]
    confirmation = UserConfirmation.find_by(c_type: :reset_password, status: :pending, token: params[:token])
    return render status: :unauthorized, json: {errors: [I18n.t('errors.invalid_token')]} if confirmation.nil?
    confirmation.user.update(confirmed_at: Time.zone.now) unless confirmation.user.confirmed?
    return render status: :unauthorized, json: {errors: [I18n.t('errors.late_token')]} if confirmation.created_at + RESET_TOKEN_LIFETIME < Time.zone.now
    confirmation.update(status: :approved)
    session = Session.create(user: confirmation.user)
    token = JsonWebToken.encode({user_id: confirmation.user.id, uid: session.uid, exp: 1.hours.from_now.to_i})
    redirect_to EMAIL_RESET_SITE + "?token=#{token}"
  end

  # Change user password
  def change_password
    @user = current_user
    return render status: :unprocessable_entity, json: {errors: [I18n.t('errors.insufficient_params')]} unless params[:password] && params[:password_confirmation] && params[:password] == params[:password_confirmation]
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render status: :ok, json: {message: I18n.t('messages.password_reset')}
    else
      render status: :unprocessable_entity, json: {errors: @user.errors.full_messages}
    end
  end
end