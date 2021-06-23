class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :folowings, :followers, :likes]
  before_action :user_id, only: [:show, :followings, :followers, :likes]
  
  def index
    @pagy, @users = pagy(User.order(id: :desc), items: 20)
  end

  def show
    @pagy, @microposts = pagy(@user.microposts.order(id: :desc))
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @pagy, @followings = pagy(@user.followings)
    counts(@user)
  end
  
  def followers
    @pagy, @followers = pagy(@user.followers)
    counts(@user)
  end
  
  def likes
    @pagy, @favorite_feed_microposts = pagy(@user.favorite_microposts)
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def user_id
    @user = User.find(params[:id])
  end
end
