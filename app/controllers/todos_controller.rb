class TodosController < ProtectedController
  def new
    @project = Project.includes(checklists: :todos).find(params[:project_id])
    @checklist = @project.checklists.find(params[:checklist_id])
    @todo = @checklist.todos.new
  end

  def create
    checklist = Checklist.find(params[:checklist_id])
    @todo = checklist.todos.new(todo_params)
    if @todo.save!
      redirect_to project_path(checklist.project)
    else
      render :new
    end
  end

  def destroy
    @todo = Todo.find(params[:id]).destroy!
    redirect_to project_path(@todo.checklist.project)
  end

  private
    def todo_params
      params.require(:todo).permit(:description, :completed)
    end
end