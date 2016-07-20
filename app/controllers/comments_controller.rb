class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @user.comments.reverse
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.valid?
      @comment.save
      redirect_to project_task_path(find_project, find_task)
    else
      @task = Task.find_by(id: params[:comment][:task_id])
      @comment = Comment.new(comment_params)
      redirect_to project_task_path(find_project, find_task)
    end
  end

  def edit
    @task = @comment.task
  end

  def update
    @comment.update(comment_params)
    redirect_to project_task_path(find_project, find_task)
  end

  def destroy
    @comment.destroy
    redirect_to project_task_path(find_project, find_task)
  end


  private
  def set_user
    @user = current_user
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def find_task
    Task.find_by(id: @comment.task_id)
  end

  def find_project
    Project.find_by(id: find_task.project_id)
  end

  def comment_params
    params.require(:comment).permit(:content, :task_id, :user_id)
  end
end
