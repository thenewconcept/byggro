require 'rails_helper'

RSpec.describe Calculator::Rot, type: :model do
  before do
    stub_const("Project::ROT_PERCENT", 0.20)
    stub_const("Reportable::HOURLY_RATE", 500)
  end

  describe "#hours" do
    it "for fixed workorders, returns fixed amount divided by Project::HOURLY_RATE hourly rate" do
      workorder = create(:checklist, bonus: :fixed, amount: '5000')

      calculator = Calculator::Rot.new(workorder)

      expect(calculator.hours).to eq(10)
    end

    it "for hourly workorders, returns the hours reported" do
      workorder = create(:checklist, bonus: :none)
      create(:report, reportable: workorder, time_in_hours: 8)
      create(:report, reportable: workorder, time_in_hours: 8)

      calculator = Calculator::Rot.new(workorder)

      expect(calculator.hours).to eq(16)
    end

    it "for project it sums the hours from each workorder" do
      project = create(:project)
      create(:checklist, project:, bonus: :fixed, amount: 5000) # Fixed: 10 hours
      hourly_workorder = create(:checklist, project:, bonus: :none) # Will total to 16 hours
      create(:report, reportable: hourly_workorder, time_in_hours: 8)
      create(:report, reportable: hourly_workorder, time_in_hours: 8)

      calculator = Calculator::Rot.new(project)

      expect(calculator.hours).to eq(26)
    end
  end
end