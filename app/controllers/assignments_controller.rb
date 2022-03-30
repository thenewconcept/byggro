class AssignmentsController < ProtectedController
  def new
    @project = Project.find(params[:project_id])
    @assignment = @project.assignments.new
    authorize(@assignment)
  end

  def create
    @project   = Project.find(params[:project_id])
    @assignment = @project.assignments.new(assignment_params)
    authorize(@assignment)

    if @assignment.save!
      redirect_to project_url(@project, tab: 'checklist')
    else
      render :new
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit(:user_id, :project_id)
  end
end