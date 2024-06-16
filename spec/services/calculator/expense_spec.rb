require 'rails_helper'

RSpec.describe Calculator::Expense, type: :model do
  describe "#total" do
    it 'returns the expense total for a project' do
      project = create(:project)
      create(:expense, project:, amount: 1000)
      create(:expense, project:, amount: 500)

      calculator = Calculator::Expense.new(project)

      expect(calculator.total).to eq(1500)
    end
  end
end