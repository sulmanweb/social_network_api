class V1::Auth::RegistrationsController < ApplicationController

  before_action :authenticate_user, only: %i[destroy]

  def create
    @user = User.new register_params

    if @user.save
      return render_success_register_user
    else
      return render_error_save @user
    end
  end

  def destroy
    current_user.destroy!
    render status: :no_content, json: {}
  end

  protected

  def render_success_register_user
    render status: :created, template: 'v1/auth/register.json.jbuilder'
  end

  private

  def register_params
    params.permit :name, :email, :username, :password, :password_confirmation
  end
end