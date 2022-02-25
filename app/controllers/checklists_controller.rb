class ChecklistsController < ProtectedController
  def edit
    @project = Project.find(params[:project_id])
    @checklist = @project.checklists.find(params[:id])
    authorize(@checklist)
  end

  def create
    @project   = Project.find(params[:project_id])
    @checklist = @project.checklists.new(title: 'Ny Arbetslista')
    authorize(@checklist)

    if @checklist.save!
      redirect_to project_url(@project, tab: 'checklist')
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @checklist = @project.checklists.find(params[:id])
    authorize(@checklist)

    if @checklist.update!(checklist_params)
      redirect_to project_url(@project, tab: 'checklists', status: 303)
    else
      render :edit
    end
  end

  def destroy
    @project   = Project.find(params[:project_id])
    @checklist = @project.checklists.find(params[:id])
    authorize(@checklist)
    @checklist.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@checklist) }
      format.html { redirect_to project_url(@project, tab: 'checklists') }
    end
  end

  private
    def checklist_params
      params.require(:checklist).permit(:title)
    end
end