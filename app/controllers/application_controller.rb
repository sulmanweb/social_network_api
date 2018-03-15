class ApplicationController < ActionController::API

  # returns errors in object
  def render_error_save status = :unprocessable_entity, obj
    render status: status, json: {errors: obj.errors.full_messages}
  end
end
