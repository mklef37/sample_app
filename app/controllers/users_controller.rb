class UsersController < ApplicationController
before_filter :signed_in_user, only: [:index, :edit, :update]
before_filter :correct_user, only: [:edit, :update]
before_filter :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def show
    if(User.exists?(params[:id]))
  	  @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      redirect_to root_path
      flash[:error] = "The user with given ID does not exist"
    end
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      flash[:success] = "Welcome to the Sample App, Bro!"
      sign_in @user
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated! Woot!!!!1!!One!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Baboom, it's gone"
    redirect_to users_path
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
