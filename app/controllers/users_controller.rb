class UsersController < ApplicationController
  
  before_filter :signed_in_user, only:[:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
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
    	flash[:success] = "Welcome to the Sample App!"
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

private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
