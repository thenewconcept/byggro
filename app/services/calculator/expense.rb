module Calculator
  class Expense
    def initialize(resource)
      @resource = resource
    end

    def total
      @resource.expenses.sum(&:amount)
    end
  end
end