class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    @micropost = current_user.microposts.build  # form_with 用

    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def edit
    @user=User.find(params[:id])
  end
  
  def update
      @user = User.find(params[:id])
      if @user.update(name_params)
        flash[:success] = 'name は正常に更新されました'
        redirect_to root_path
      else
        flash.now[:danger] = 'name は更新されませんでした'
        render :edit
      end
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
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = '退会しました。'
    redirect_to signup_path
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def name_params
    params.require(:user).permit(:name)
  end
end
