class ReportsController < ProtectedController
  def new
    @checklist = Checklist.find(params[:checklist_id])
    @report = @checklist.reports.new(date: Date.today)
    authorize(@report)
  end

  def edit
    @checklist = Checklist.find(params[:checklist_id])
    @report      = @checklist.reports.find(params[:id])
    authorize(@report)
  end

  def create
    @checklist = Checklist.find(params[:checklist_id])
    @report      = @checklist.reports.new(report_params.merge(worker: Current.user.worker))
    authorize(@report)

    if @report.save!
      redirect_to project_url(@checklist.project, tab: 'checklist')
    else
      render :new
    end
  end

  def update
    @checklist = Checklist.find(params[:checklist_id])
    @report    = @checklist.reports.find(params[:id])
    authorize(@report)

    if @report.update!(report_params)
      redirect_to project_url(@checklist.project, tab: 'checklist', status: 303)
    else
      render :edit
    end
  end

  def destroy
    @report = Report.find(params[:id])
    authorize(@report)
    @report.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@report) }
      format.html {  redirect_to project_url(@checklist.project, tab: 'checklist') }
    end
  end

  private
    def report_params
      params.require(:report).permit(:date, :time_in_minutes, :note)
    end
end