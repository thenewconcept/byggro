class TodosController < ProtectedController
  def new
    @checklist = Checklist.find(params[:checklist_id])
    @todo = @checklist.todos.new
  end

  def edit
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.find(params[:id])
  end

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.new(todo_params)

    if @todo.save!
      redirect_to project_url(@checklist.project)
    else
      render :new
    end
  end

  def update
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.find(params[:id])

    if @todo.update!(todo_params)
      redirect_to project_url(@checklist.project)
    else
      render :edit
    end
  end

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @todo      = @checklist.todos.new(todo_params)

    if @todo.save!
      redirect_to project_url(@checklist.project)
    else
      render :new
    end
  end

  def destroy
    @todo = Todo.find(params[:id]).destroy!
    redirect_to project_url(@todo.checklist.project)
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :completed)
    end
end