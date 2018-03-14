class Error::ErrorsController < ApplicationController
  def not_found
    return render_error_not_found
  end

  def internal_server_error
    return render_error_internal_server_error
  end

  protected

  def render_error_not_found
    render status: :not_found, json: {errors: [I18n.t('errors.not_found')]}
  end

  def render_error_internal_server_error
    render status: :internal_server_error, json: {errors: [I18n.t('errors.internal_server_error')]}
  end
end