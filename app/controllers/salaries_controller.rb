class SalariesController < ProtectedController
  def index
    authorize(:salaries)
    @from = params[:from] ? Time.zone.parse(params[:from]) : Time.zone.now.beginning_of_month
    @to   = params[:to] ? Time.zone.parse(params[:to]) : Time.zone.now.end_of_month
    @salaries = Salary.new(from: @from, to: @to)
  end
end