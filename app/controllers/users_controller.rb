class UsersController < ApplicationController
  
  before_filter :signed_in_user, only:[:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  respond_to :html, :js

  def index
    if params.has_key?("search")
      @users = User.search(params[:search]).paginate(page: params[:page])
    else
      @users = User.paginate(page: params[:page])
    end
    respond_with @users
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    if signed_in?
      redirect_to root_url
    end
  	@user = User.new
  end

  def create
    if signed_in?
      redirect_to root_url
    end
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
    	flash[:success] = "welcome to chirp!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    unless current_user?(@user)
      @user.destroy
      flash[:success] = "User destroyed."
    end
    flash[alert] = "You cannot delete yourself" unless !current_user?(@user)
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
