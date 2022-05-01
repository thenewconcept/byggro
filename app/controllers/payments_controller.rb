class PaymentsController < ProtectedController
  def index
    authorize(:payment)
    @from = params[:from] ? Time.zone.parse(params[:from]) : Time.zone.now.beginning_of_month - 1.month
    @to   = params[:to] ? Time.zone.parse(params[:to]) : Time.zone.now.end_of_month - 1.month
    @payment = Payment.new(from: @from, to: @to)
  end
end