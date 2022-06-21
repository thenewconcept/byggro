class PaymentsController < ProtectedController
  before_action :set_project

  def index
  end

  def new
    @payment = Payment.new(project: @project)
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to project_path(@payment.project), notice: 'Payment was successfully created.'
    else
      render :new
    end
  end

  private
  def set_project
    @project = policy_scope(Project).find(params[:project_id]) if params[:project_id]
  end

  def payment_params
    params.require(:payment).permit(:amount, :payed_on, :project_id)
  end
end