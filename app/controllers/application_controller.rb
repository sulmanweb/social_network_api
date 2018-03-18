class ApplicationController < ActionController::API
  attr_reader :current_user

  before_action :get_current_user

  include ExceptionHandler

  # returns errors in object
  def render_error_save status = :unprocessable_entity, obj
    render status: status, json: {errors: obj.errors.full_messages}
  end

  # [...]
  private
  def authenticate_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
    return render status: :unauthorized, json: {errors: ['Unauthorized']} unless @current_user
  end

  def get_current_user
    @current_user = GetCurrentUser.call(request.headers).result
  end
end
