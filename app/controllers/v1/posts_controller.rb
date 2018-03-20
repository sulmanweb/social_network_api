class V1::PostsController < ApplicationController

  before_action :authenticate_user
  before_action :set_post, only: %i[update destroy]

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

  private

  def post_params
    params.permit(:body)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end