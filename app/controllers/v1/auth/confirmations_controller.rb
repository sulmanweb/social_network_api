class V1::Auth::ConfirmationsController < ApplicationController

  def confirm
    return render status: :unprocessable_entity, json: {errors: [I18n.t('errors.insufficient_params')]} unless params[:token]
    confirmation = UserConfirmation.find_by(c_type: :email_confirmation, status: :pending, token: params[:token])
    return render status: :unauthorized, json: {errors: [I18n.t('errors.invalid_token')]} if confirmation.nil?
    confirmation.user.update(confirmed_at: Time.zone.now) unless confirmation.user.confirmed?
    confirmation.update(status: :approved)
    redirect_to EMAIL_CONFIRMATION_SITE
  end

end