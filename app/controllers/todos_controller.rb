class TodosController < ProtectedController
  def new
    @checklist = Checklist.find(params[:checklist_id])
    @todo = @checklist.todos.new
    authorize(@todo)
  end

  def edit
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.find(params[:id])
    authorize(@todo)
  end

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.new(todo_params)
    authorize(@todo)

    if @todo.save!
      redirect_to project_url(@checklist.project, tab: 'checklist')
    else
      render :new
    end
  end

  def update
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.find(params[:id])
    authorize(@todo)

    if @todo.update!(todo_params)
      redirect_to project_url(@checklist.project, tab: 'checklist', status: 303)
    else
      render :edit
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    authorize(@todo)
    @todo.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@todo) }
      format.html {  redirect_to project_url(@checklist.project, tab: 'checklist') }
    end
    
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :completed, :position)
    end
end