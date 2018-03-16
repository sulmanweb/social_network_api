class V1::Auth::SessionsController < ApplicationController

  before_action :authenticate_user, only: %i[destroy]

  def create
    authenticate params[:auth], params[:password]
  end

  def destroy
    headers = request.headers['Authorization'].split(' ').last
    session = Session.find_by(uid: JsonWebToken.decode(headers)[:uid])
    session.update(status: false)
    render status: :no_content, json: {}
  end

  private

  def authenticate auth, password
    @command = AuthenticateUser.call(auth, password)

    if @command.success?
      return render_success_login
    else
      return render_error_login
    end
  end

  protected

  def render_success_login
    render status: :created, template: 'v1/auth/login.json.jbuilder'
  end

  def render_error_login
    render status: :unauthorized, json: {errors: @command.errors[:user_authentication]}
  end
end