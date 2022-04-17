class ExpensesController < ProtectedController
  before_action :set_project
  def index
    @expenses = @project.expenses.order(spent_on: :desc).all
  end

  def new
    @expense = @project.expenses.new(spent_on: Date.today)
    authorize(@expense)
  end

  def edit
    @expense = @project.expenses.find(params[:id])
    authorize(@expense)
  end

  def create
    @expense = @project.expenses.new(expense_params)
    @expense.user = Current.user
    authorize(@expense)

    if @expense.save!
      redirect_to project_url(@project, tab: 'expenses', tab: 'expenses')
    else
      render :new
    end
  end

  def update
    @expense = @project.expenses.find(params[:id])
    authorize(@expense)

    if @expense.update!(expense_params)
      redirect_to project_url(@project, tab: 'expenses'), status: 303
    else
      render :edit
    end
  end

  def destroy
    @expense = @project.expenses.find(params[:id])
    authorize(@expense)
    @expense.destroy!
    redirect_to project_expenses_url
  end

  private

    def set_project
      @project = policy_scope(Project).find(params[:project_id])
    end

    def expense_params
      params.require(:expense).permit(:spent_on, :amount, :description, :category)
    end
end