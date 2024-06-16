require 'rails_helper'

RSpec.describe Calculator::Base, type: :model do
  before do
    stub_const("Taxes::EMPLOYER_TAX", 0.20)
    stub_const("Taxes::VACATION_TAX", 0.20)
    stub_const("Taxes::VAT", 0.20)
  end

  describe "#total_expenses" do
    it 'returns the expense total for a project' do
      project = create(:project)
      create(:expense, project:, amount: 100)
      create(:expense, project:, amount: 500)

      calculator = Calculator::Base.new(project)

      expect(calculator.total_expenses).to eq(600)
    end
  end

  describe "#total_taxes" do
    it 'returns the salary and bonus taxes for a project' do
      project = create(:project)
      create(:employee, salary: 100)
      hourly_workorder = create(:checklist, payout: :hourly, project:)
      bonus_workorder = create(:checklist, payout: :fixed, project:, amount: 1000)
      create(:report, reportable: hourly_workorder, time_in_hours: 10)
      create(:report, reportable: bonus_workorder, time_in_hours: 10)

      calculator = Calculator::Base.new(project)

      expect(calculator.total_taxes).to eq(800)
    end
  end

  describe "#total_costs" do
    it "returns all costs including tax expenses, not VAT" do
      project = create(:project)
      create(:expense, project:, amount: 100)
      create(:expense, project:, amount: 500)
      employee = create(:employee, salary: 100)
      workorder_hourly = create(:checklist, payout: :hourly, project:)
      _workorder_bonus = create(:checklist, payout: :fixed, project:, amount: 1000)

      create(:report, reportable: workorder_hourly, reportee: employee, time_in_hours: 10)

      calculator = Calculator::Base.new(project)

      # expenses 600 + (hourly work 1400 inc. tax) + (bonus work 1400 inc. tax)
      expect(calculator.total_costs).to eq(3400)
    end
  end

  describe "#total_revenue" do
    it "returns total revenue for a specific project" do
      project = create(:project, misc_amount: 1000, material_amount: 1000)
      create(:employee, salary: 100)
      hourly_workorder = create(:checklist, payout: :hourly, project:, hourly_rate: 500)
      bonus_workorder = create(:checklist, payout: :fixed, project:, amount: 1000)
      create(:report, reportable: hourly_workorder, time_in_hours: 10)
      create(:report, reportable: bonus_workorder, time_in_hours: 10)

      calculator = Calculator::Base.new(project)

      # 2000 material, 5000 hourly, 1000 bonus
      expect(calculator.total_revenue).to eq(8000)
    end

    it "returns total revenue for a hourly checklist" do
      project = create(:project, misc_amount: 0, material_amount: 0)
      create(:employee, salary: 100)
      hourly_workorder = create(:checklist, payout: :hourly, project:, hourly_rate: 500)
      create(:report, reportable: hourly_workorder, time_in_hours: 10)

      calculator = Calculator::Base.new(project)

      expect(calculator.total_revenue).to eq(5000)
    end

    it "returns total revenue for a bonus checklist" do
      project = create(:project, misc_amount: 0, material_amount: 0)
      create(:employee, salary: 100)
      bonus_workorder = create(:checklist, payout: :fixed, project:, amount: 1000)
      create(:report, reportable: bonus_workorder, time_in_hours: 5)

      calculator = Calculator::Base.new(bonus_workorder)

      expect(calculator.total_revenue).to eq(1000)
    end
  end

  describe "#total_profit" do
    it "returns the profit for a bonus project" do
      employee = create(:employee)
      project = create(:project, misc_amount: 0, material_amount: 1000)
      bonus_workorder = create(:checklist, payout: :fixed, project:, amount: 1000)

      calculator = Calculator::Base.new(project)

    end
  end
end