class V1::HomeController < ApplicationController
  before_action :authenticate_user

  def timeline
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
    users = current_user.friends
    users.push current_user
    @posts = Post.where(user_id: users.pluck(:id)).where('created_at <= ?', @timestamp).order(id: :desc).page(page).per(@limit)
    render status: :ok, template: "v1/home/timeline.json.jbuilder"
  end
end
