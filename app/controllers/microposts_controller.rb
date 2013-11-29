class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :create, :destroy]
  before_filter :correct_user,   only: :destroy

  respond_to :html, :js

  def index
    if params.has_key?("search")
      @microposts = Micropost.search(params[:search]).paginate(page: params[:page])
    else
      @microposts = Micropost.paginate(page: params[:page])
    end
    respond_with @microposts
  end

  def create
  	@micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end
end