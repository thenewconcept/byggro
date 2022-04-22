class ReportsController < ProtectedController
  def index
    authorize(:report)
    @from = params[:from] ? Time.zone.parse(params[:from]) : Time.zone.now.beginning_of_month
    @to   = params[:to] ? Time.zone.parse(params[:to]) : Time.zone.now.end_of_month
    @reports = policy_scope(Report).where(date: @from..@to).order(date: :asc).all
  end

  def new
    @report = Report.new(
      date: Date.today,
      reportable_type: params[:reportable_type],
      reportable_id: params[:reportable_id]
    )

    authorize(@report)
  end

  def create
    @report = Report.new(report_params.merge(reportee: Current.user.profile))
    authorize(@report)

    if @report.save!
      flash.now[:now] = 'Tidrapporten har sparats.'
      redirect_to project_url(@report.project)
    else
      render :new
    end
  end

  def edit
    @report = Report.find(params[:id])
    authorize(@report)
  end

  def update
    @report    = Report.find(params[:id])
    authorize(@report)

    if @report.update!(report_params)
      redirect_to project_url(@report.project, tab: 'time')
    else
      render :edit
    end
  end

  def destroy
    @report = Report.find(params[:id])
    authorize(@report)
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to project_url(@report.project, tab: 'time'), notice: 'Rapport borttaget.' }
    end
  end

  private
    def report_params
      params.require(:report).permit(:date, :time_in_hours, :time_formated, :note, :reportable_type, :reportable_id) 
    end
end