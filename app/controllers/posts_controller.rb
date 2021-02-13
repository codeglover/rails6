class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  # before_action :authenticate_user!
  def index
    @posts = Post.all
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@post, partial: "posts/form", locals: { post: @post}) }
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :publish_date, :happy, :scale, kids_attributes: [:id, :hn_id, :parent_id, :by, :text, :dead, :time, :location, :_destroy])
  end
end
