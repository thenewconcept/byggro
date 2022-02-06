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
      redirect_to project_url(@checklist.project)
    else
      render :new
    end
  end

  def update
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.find(params[:id])
    authorize(@todo)

    if @todo.update!(todo_params)
      redirect_to project_url(@checklist.project)
    else
      render :edit
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    authorize(@todo)
    @todo.destroy!
    redirect_to project_url(@todo.checklist.project)
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :completed)
    end
end