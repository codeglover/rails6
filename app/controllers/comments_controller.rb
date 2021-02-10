class CommentsController < ApplicationController

  def index
    @post = Post.find_by_hn_id params[:post_id]

    http = HTTP.persistent "https://hacker-news.firebaseio.com"
    post_json = JSON.parse http.get("/v0/post/#{@post.hn_id}.json").to_s

    if post_json.nil?
      return
    end
    @post.populate(post_json)
    @post.save
    load_kids(http, @post.hn_id, post_json)
  end

  def show
    http = HTTP.persistent "https://hacker-news.firebaseio.com"
    @post = Post.find_by_hn_id params[:post_id]
    @comment = Comment.find_by_hn_id params[:id]
    post_json = JSON.parse http.get("/v0/post/#{@comment.hn_id}.json").to_s
    if post_json.nil?
      return
    end
    @comment.populate(post_json)
    @comment.save
    load_kids(http, @comment.hn_id, post_json)
  end

  private

  def load_kids(http, parent_id, post_json)
    if post_json and post_json.has_key? 'kids'
      post_json['kids'].each_with_index do |kid_hn_id, kid_location|

        kid_json = JSON.parse http.get("/v0/post/#{kid_hn_id}.json").to_s
        if kid_json.nil?
          next
        end

        kid = Comment.where(hn_id: kid_hn_id).first_or_create
        kid.location = kid_location
        kid.parent_id = parent_id
        kid.populate(kid_json)
        kid.save
      end
    end
  end
end