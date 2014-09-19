class CommentsController < ApplicationController
  #before_filter :set_picture

  respond_to :js
  def index
    @comments = Comment.search(query: {match: {'picture.id' => params[:picture_id]}})
  end

  def create
    @picture = Picture.get!(params[:picture_id])
    @comment = @picture.comments.create(comment: params[:comment][:comment], user: current_user)
  end

  private
  def set_picture
    
  end
end
