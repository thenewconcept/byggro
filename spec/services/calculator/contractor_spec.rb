require 'rails_helper'

RSpec.describe Calculator::Contractor, type: :model do
  describe "#total" do
    it 'returns the cost of contractors in a project' do
      contractor = create(:contractor, fee: 100)
      project = create(:project)
      workorder = create(:checklist, project: project)

      create(:report, reportee: contractor, reportable: workorder, time_in_hours: 10)

      calculator = Calculator::Contractor.new(project)

      expect(calculator.total).to eq(1000)
    end

    it 'should not include salaries' do
      employee = create(:employee, salary: 100)
      project = create(:project)
      workorder = create(:checklist, project: project)

      create(:report, reportee: employee, reportable: workorder, time_in_hours: 10)

      calculator = Calculator::Contractor.new(project)

      expect(calculator.total).to eq(0)
    end
  end
end