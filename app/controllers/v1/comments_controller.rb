class V1::CommentsController < ApplicationController

  before_action :authenticate_user
  before_action :set_post
  before_action :set_comment, only: %i[update destroy]

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
    @comments = @post.comments.where('created_at <= ?', @timestamp).order(id: :desc).page(page).per(@limit)
    render status: :ok, template: 'v1/comments/index.json.jbuilder'
  end

  def create
    @comment = @post.comments.build comment_params
    @comment.user = current_user
    if @comment.save
      render status: :created, template: 'v1/comments/show.json.jbuilder'
    else
      render status: :unprocessable_entity, json: {errors: @comment.errors.full_messages}
    end
  end

  def update
    authorize @comment
    if @comment.update comment_params
      render status: :ok, template: 'v1/comments/show.json.jbuilder'
    else
      render status: :unprocessable_entity, json: {errors: @comment.errors.full_messages}
    end
  end

  def destroy
    authorize @comment
    @comment.destroy!
    render status: :no_content, json: {}
  end

  private

  def set_post
    @post = Post.find params[:post_id]
  end

  def comment_params
    params.permit(:body)
  end

  def set_comment
    @comment = @post.comments.find params[:id]
  end
end