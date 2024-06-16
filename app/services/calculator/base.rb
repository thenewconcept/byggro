module Calculator
  class Base
    include Taxes

    attr_reader :revenue, :expenses, :contractor, :salary, :taxes, :bonus, :resource, :rot

    def initialize(resource)
      @resource = resource
      @revenue = Revenue.new(@resource)
      @expenses = Expense.new(@resource)
      @contractor = Contractor.new(@resource)
      @salary = Salary.new(@resource)
      @bonus = Bonus.new(@resource)
      @rot = Rot.new(@resource)
    end

    def total_expenses
      @total_expenses ||= expenses.total
    end
    
    def total_costs
      @total_costs ||= contractor.total + expenses.total + salary.including_taxes + bonus.including_taxes
    end

    def total_revenue
      @total_revenue ||= revenue.total
    end

    def total_taxes
      @total_taxes ||= salary.taxes + bonus.taxes
    end

    def total_profit
      @total_profit ||= total_revenue - total_costs
    end

    def total_margin
      @total_margin ||= total_profit / total_revenue * 100
    end
  end
end