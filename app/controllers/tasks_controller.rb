class TasksController < ApplicationController
  layout 'dashboard'
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :authorize

  # GET /users/:id/tasks
  # GET /users/:id/tasks.json
  def index
    @tasks = User.find(params[:user_id]).tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /users/:id/tasks/new
  def new
    @task = Task.new
    Deadline.new(task: @task)
    @user = current_user || User.find(params[:user_id])
  end

  # GET /tasks/1/edit
  def edit
    Deadline.new(task: @task) unless @task.deadline
  end

  # POST users/:id/tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user_id ||= params[:user_id]

    respond_to do |format|
      if @task.save
        format.html { redirect_to user_tasks_path(@task.user) }
        format.json { render :show, status: :created, location: @task }
      else

        format.html do 
          @user = @task.user
          render :new
        end

        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if params[:position]
      @task.set_list_position(params.delete(:position))
    end

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to user_tasks_path(@task.user) }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to user_tasks_url(current_user) }
      format.json { head :no_content }
    end
  end

  private
    def authorize
      uid = params[:user_id] || @task.user.id
      redirect_to new_user_session_path unless current_user == User.find(uid)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(
        :title, 
        :status, 
        :priority, 
        :notes, 
        :position,
        :deadline_attributes => [:id, :date, :description]
      )
    end
end
