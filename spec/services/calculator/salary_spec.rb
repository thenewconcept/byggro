require 'rails_helper'

RSpec.describe Calculator::Salary, type: :model do
  before do
    stub_const("Taxes::EMPLOYER_TAX", 0.20)
    stub_const("Taxes::VACATION_TAX", 0.20)
  end

  describe "#excluding_taxes" do
    it do
      employee = create(:employee, salary: 100)
      project = create(:project)
      workorder = create(:checklist, payout: :hourly, project:)

      create(:report, reportable: workorder, reportee: employee, time_in_hours: 9)

      salaries = Calculator::Salary.new(project)

      expect(salaries.excluding_taxes).to eq(900)
    end
    
    it "only includes non-bonus work orders, which are in Calculator::Bonus" do
      employee = create(:employee, salary: 100)
      project = create(:project)
      workorder_hourly = create(:checklist, payout: :hourly, project:)
      _workorder_bonus = create(:checklist, payout: :fixed, project:, amount: 1000)

      create(:report, reportable: workorder_hourly, reportee: employee, time_in_hours: 9)

      salaries = Calculator::Salary.new(project)

      expect(salaries.excluding_taxes).to eq(900)
    end
  end

  describe "#including_taxes" do
    it do
      employee = create(:employee, salary: 100)
      project = create(:project)
      workorder = create(:checklist, payout: :hourly, project:)

      create(:report, reportable: workorder, reportee: employee, time_in_hours: 10)

      salaries = Calculator::Salary.new(project)

      expect(salaries.including_taxes).to eq(1400)
    end
  end

  describe "#taxes" do
    it do
      employee = create(:employee, salary: 100)
      project = create(:project)
      workorder = create(:checklist, payout: :hourly, project:)

      create(:report, reportable: workorder, reportee: employee, time_in_hours: 10)

      salaries = Calculator::Salary.new(project)

      expect(salaries.taxes).to eq(400)
    end
  end
end