class V1::UsersController < ApplicationController

  before_action :authenticate_user, only: %i[request_friend accept_friend]
  before_action :set_user, only: %i[request_friend accept_friend]

  def index
    @limit = if params[:limit] then
               params[:limit].to_i
             else
               PAGE_LIMIT
             end
    page = if params[:page] then
             params[:page].to_i
           else
             1
           end
    @timestamp = if params[:timestamp] then
                   params[:timestamp].to_datetime
                 else
                   Time.zone.now
                 end
    @users = if current_user then
               User.where('created_at <= ?', @timestamp).where.not(id: current_user.id).order(id: :desc).page(page).per(@limit)
             else
               User.where('created_at <= ?', @timestamp).order(id: :desc).page(page).per(@limit)
             end
    render status: :ok, template: 'v1/users/index.json.jbuilder'
  end

  def request_friend
    authorize @user
    if current_user.friend_request @user
      FriendshipsMailer.requested(@user.id, current_user.id).deliver_later
      render status: :ok, json: {message: I18n.t('messages.friend_request_sent')}
    else
      render status: :unprocessable_entity, json: {errors: [I18n.t('errors.users.friend_request')]}
    end
  end

  def accept_friend
    authorize @user
    if current_user.accept_request @user
      FriendshipsMailer.accepted(@user.id, current_user.id)
      render status: :ok, json: {message: I18n.t('messages.friend_request_accepted')}
    else
      render status: :unprocessable_entity, json: {errors: [I18n.t('errors.users.friend_accept')]}
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end
end