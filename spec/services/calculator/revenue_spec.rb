require 'rails_helper'

RSpec.describe Calculator::Revenue, type: :model do
  describe "#amount" do
    it "returns revenue amount for fixed work orders" do
      project = create(:project)
      create(:checklist, project:, payout: :fixed, amount: 1000)
      create(:checklist, project:, payout: :fixed, amount: 200)

      calculator = Calculator::Revenue.new(project)

      expect(calculator.amount).to eq(1200)
    end

    it "returns revenue amount for hourly work orders" do
      project = create(:project)
      per_hour = create(:checklist, project:, payout: :hourly, hourly_rate: 500)
      per_item = create(:checklist, project:, payout: :hourly, hourly_rate: 500)
      create(:report, reportable: per_hour, time_in_hours: 10)
      create(:report, reportable: per_item, time_in_hours: 2)

      per_hour_revenue = Calculator::Revenue.new(per_hour).amount
      per_item_revenue = Calculator::Revenue.new(per_item).amount

      expect(per_hour_revenue).to eq(5000)
      expect(per_item_revenue).to eq(1000)
    end

    it "returns zero when no reports are present" do
      project = create(:project)
      per_hour = create(:checklist, project:, payout: :hourly, hourly_rate: 500)

      calculator = Calculator::Revenue.new(per_hour).amount

      expect(calculator).to eq(0)
    end
  end
  
  describe "#material" do
    it "returns material revenue for project" do
      project = create(:project, material_amount: 1200)

      calculator = Calculator::Revenue.new(project)

      expect(calculator.material).to eq(1200)
    end

    it "returns zero for checklists" do
      checklist = create(:checklist)

      calculator = Calculator::Revenue.new(checklist)

      expect(calculator.material).to eq(0)
    end
  end

  describe "#other" do
    it "returns miscellanous revenue for project" do
      project = create(:project, misc_amount: 900)

      calculator = Calculator::Revenue.new(project)

      expect(calculator.other).to eq(900)
    end

    it "returns zero for checklists" do
      checklist = create(:checklist)

      calculator = Calculator::Revenue.new(checklist)

      expect(calculator.other).to eq(0)
    end
  end

  describe "#total" do
    it "returns total revenue for project" do
      project = create(:project, material_amount: 1200, misc_amount: 800)
      create(:checklist, project:, payout: :fixed, amount: 1000)
      create(:checklist, project:, payout: :fixed, amount: 500)

      calculator = Calculator::Revenue.new(project)

      expect(calculator.total).to eq(3500)
    end

    it "returns total revenue for checklists" do
      per_hour = create(:checklist, payout: :hourly, hourly_rate: 500)
      per_item = create(:checklist, payout: :fixed, amount: 500)
      create(:report, reportable: per_hour, time_in_hours: 10)

      per_hour_revenue = Calculator::Revenue.new(per_hour).total
      per_item_revenue = Calculator::Revenue.new(per_item).total

      expect(per_hour_revenue).to eq(5000)
      expect(per_item_revenue).to eq(500)
    end
  end
end