class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :update, :show]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    @micropost = current_user.microposts.build  # form_with 用
  end
  def edit
    @user = current_user
  end
  def update
    if @micropost.update(micropost_params )
      flash[:success] = 'micropost updated'
      #render 'toppages/index'
      redirect_to user_path(@micropost.user)
    else
      flash.now[:danger] = 'micropost was not updated'
      render :edit
    end
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'message posted。'
      redirect_back(fallback_location: current_user)
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'failed to posted。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'message deleted'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end