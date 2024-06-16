class SalariesController < ProtectedController
  def index
    authorize(:salaries)
    @from = params[:from] ? Time.zone.parse(params[:from]) : Time.zone.now.beginning_of_month
    @to   = params[:to] ? Time.zone.parse(params[:to]) : Time.zone.now.end_of_month
    @payroll     = Payroll.new(@from..@to)
  end
end