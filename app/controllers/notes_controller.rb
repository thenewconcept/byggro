class NotesController < ProtectedController
  before_action :set_project
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = @project.notes.all
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = @project.notes.new
  end

  # GET /notes/1/edit
  def edit
    authorize @note
  end

  # POST /notes or /notes.json
  def create
    @note = @project.notes.new(note_params.merge(user: Current.user))

    respond_to do |format|
      if @note.save!
        format.html { redirect_to project_url(@project, tab: 'journal'), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    authorize @note
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to project_url(@project, tab: 'journal'), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    authorize @note
    @note.destroy

    respond_to do |format|
      format.html { redirect_to project_url(@project, tab: 'journal'), notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_note
      @note = @project.notes.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:project_id, :content)
    end
end
