class PicturesController < ApplicationController
  def index
    @title = 'My Bucket'
    @pictures = current_user.pictures.paginate(page: params[:page], per_page: 5)
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = current_user.pictures.new(params[:picture])

    if @picture.save
      redirect_to @picture, notice: 'Photo has been added to your bucket.'
    else
      flash.now.alert = 'There was some problem while adding your photo. Please try again.'
      render :new
    end
  end

  def show
    @picture = Picture.get!(params[:id])
    @comment = @picture.comments.new
  end

  def world_bucket
    @title = 'World Bucket'
    @pictures = Picture.paginate(page: params[:page], per_page: 5)

    render :index
  end
end
