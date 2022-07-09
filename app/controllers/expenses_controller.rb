class ExpensesController < ProtectedController
  before_action :set_project 
  before_action :set_refferer, only: [:new, :edit]

  def index
    authorize(:expense)

    @from = params[:from] ? Time.zone.parse(params[:from]) : Time.zone.now.beginning_of_month
    @to   = params[:to] ? Time.zone.parse(params[:to]) : Time.zone.now.end_of_month

    @expenses = policy_scope(Expense).where(spent_on: @from..@to).order(spent_on: :desc)
  end

  def new
    @expense = Expense.new(spent_on: Date.today, project: @project)
    @expense.user_id = Current.user.id
    authorize(@expense)
  end

  def edit
    @expense = Expense.find(params[:id])
    authorize(@expense)
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = params[:expense][:user_id].presence || Current.user.id
    authorize(@expense)

    if @expense.save!
      redirect_to_refferer_or(expenses_url, status: 303) 
    else
      render :new
    end
  end

  def update
    @expense = Expense.find(params[:id])
    authorize(@expense)

    if @expense.update!(expense_params)
      redirect_to_refferer_or(expenses_url, status: 303) 
    else
      render :edit
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    authorize(@expense)
    @expense.destroy!
    redirect_to redirect_path, status: 303
  end

  private

    def set_project
      @project = policy_scope(Project).find(params[:project_id]) if params[:project_id]
    end

    def set_refferer
      super http_referrer
    end

    def expense_params
      params.require(:expense).permit(:user_id, :project_id, :spent_on, :amount, :description, :category)
    end
end