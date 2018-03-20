class ApplicationController < ActionController::API
  include Pundit
  attr_reader :current_user

  before_action :get_current_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  private

  def user_not_authorized exception
    policy_name = exception.policy.class.to_s.underscore
    render json: {errors: [I18n.t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)]}, status: :forbidden
  end
end
