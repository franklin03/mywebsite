class TasksController < ApplicationController
  
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @task  = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskが作成されました'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'Taskが作成されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'task updated'
      redirect_to @task 
    else
      flash.now[:danger] = 'task update failed'
      render :new
    end
  end

  def destroy
    @task.destroy;
    
    flash[:success] = 'task deleted'
    redirect_to tasks_url 
    
  end
  
  private 

  def task_params
    params.require(:task).permit(:content,:status, :user)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
