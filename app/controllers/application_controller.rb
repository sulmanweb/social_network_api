class ApplicationController < ActionController::API
  attr_reader :current_user

  include ExceptionHandler

  # returns errors in object
  def render_error_save status = :unprocessable_entity, obj
    render status: status, json: {errors: obj.errors.full_messages}
  end

  # [...]
  private
  def authenticate_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
    return render_error_save :unauthorized, {errors: {full_messages: ['Unauthorized']}} unless @current_user
  end
end
