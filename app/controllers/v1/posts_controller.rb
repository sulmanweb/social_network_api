class V1::PostsController < ApplicationController

  before_action :authenticate_user, only: %i[create update destroy]
  before_action :set_post, only: %i[update destroy]
  before_action :set_user, only: %i[user_posts]

  def create
    @post = current_user.posts.build post_params
    if @post.save
      render status: :created, template: 'v1/posts/show.json.jbuilder'
    else
      render status: :unprocessable_entity, json: {errors: @post.errors.full_messages}
    end
  end

  def update
    authorize @post
    if @post.update post_params
      render status: :ok, template: 'v1/posts/show.json.jbuilder'
    else
      render status: :unprocessable_entity, json: {errors: @post.errors.full_messages}
    end
  end

  def destroy
    authorize @post
    @post.destroy!
    render status: :no_content, json: {}
  end

  def user_posts
    @limit = params[:limit].to_i || PAGE_LIMIT
    page = params[:page].to_i || 1
    @timestamp = if params[:timestamp] then
                   params[:timestamp].to_datetime
                 else
                   Time.zone.now
                 end
    @posts = @user.posts.where('created_at <= ?', @timestamp).order(id: :desc).page(page).per(@limit)
    render status: :ok, template: 'v1/posts/index.json.jbuilder'
  end

  private

  def post_params
    params.permit(:body)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end