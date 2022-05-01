class ProjectsController < ProtectedController 
  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects or /projects.json
  def index
    @projects  = policy_scope(Project).order(starts_at: :asc)

    if params[:status]
      @projects = @projects.where(status: params[:status])
    else
      @projects = @projects.status_started
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
    @reports    = Report.by_project(@project)
    @calculator = Bonus::Calculator.for(@project)
    authorize(@project, :salary?) if params[:tab] == 'employee'
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project
  end

  # GET /projects/1/edit
  def edit
    authorize @project
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    authorize @project

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    authorize @project
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    authorize @project
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.includes(checklists: :todos).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, 
        :description, 
        :completed_at,
        :starts_at,
        :due_at,
        :adress, 
        :material_amount, 
        :fixed_fee, 
        :misc_amount, 
        :is_rot, 
        :bonus, 
        :status, 
        :hourly_rate)
    end
end
