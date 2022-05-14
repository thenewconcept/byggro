require 'rails_helper'

RSpec.describe Bonus::Calculator do

  let(:normal_project)  { create(:project, hourly_rate: 500, bonus: :none) }
  let(:hourly_project)  { create(:project, hourly_rate: 500, bonus: :hourly) }
  let(:fixed_project)   { create(:project, bonus: :fixed, fixed_fee: 0.35) }

  let!(:normal_checklist) { create(:checklist, amount: 10000, project: normal_project) }
  let!(:hourly_checklist) { create(:checklist, amount: 10000, project: hourly_project) }
  let!(:fixed_checklist)  { create(:checklist, amount: 10000, project: fixed_project) }

  let(:john)      { create(:employee, salary: 200) } # Bonus Base: 100
  let(:jim)       { create(:employee, salary: 100) } # Bonus Base: 100
  let(:jill)      { create(:intern) } # No bonus, no salary.
  let(:jake)       { create(:contractor, fee: 400) } # No bonus, fixed fee.

  let(:calc_normal) { Bonus::Calculator.for(normal_project) }
  let(:calc_hourly) { Bonus::Calculator.for(hourly_project) }
  let(:calc_fixed)  { Bonus::Calculator.for(fixed_project) }

  before do
    # Used to calculate bonus base for workers. 
    stub_const('Bonus::Hourly::BONUS_INDEX', 300)

    # Hourly project has an hourly target of 20 hours.
    # I.e. Checklists amount total / hourly rate.
    # Completed on 16 hours total, 80% of the time gives 20% bonus time.
    create(:report, time_in_hours: 3, reportable: hourly_checklist, reportee: john)
    create(:report, time_in_hours: 5, reportable: hourly_checklist, reportee: jim)
    create(:report, time_in_hours: 4, reportable: hourly_checklist, reportee: jill)
    create(:report, time_in_hours: 4, reportable: hourly_checklist, reportee: jake)

    # Fixed project has an project fee of 3500.
    create(:report, time_in_hours: 4, reportable: fixed_checklist, reportee: john)
    create(:report, time_in_hours: 6, reportable: fixed_checklist, reportee: jim)
    create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: jill)
    create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: jake)
  end

  describe '#bonus_percent' do
    it 'returns 20% for the hourly bonus' do
      expect(calc_hourly.bonus_percent(john)).to eq(0.20)
      expect(calc_hourly.bonus_percent(jim)).to eq(0.20)

      expect(calc_hourly.bonus_percent(jim)).to eq(0.20)
      expect(calc_hourly.bonus_percent(jake)).to eq(0.20)
    end

    it 'returns %-portion of total hours on fixed projects' do
      expect(calc_fixed.bonus_percent(john)).to eq(0.27) # 4 hours of 15 worker hours.
      expect(calc_fixed.bonus_percent(jim)).to eq(0.4) # 6 hours of 15 worker hours.

      expect(calc_hourly.bonus_percent(jim)).to eq(0.2)
      expect(calc_hourly.bonus_percent(jake)).to eq(0.2)
    end
  end

  describe '#bonus_for' do
    it 'returns bonus percent of the bonus base x hours worked' do
      expect(calc_hourly.bonus_for(jim)).to eq(100) # Bonus Base: 100 x 0.2 x 5 hours worked = 100
      expect(calc_hourly.bonus_for(john)).to eq(60) # Bonus Base: 100 x 0.2 x 3 hours worked = 60

      expect(calc_hourly.bonus_for(jill)).to eq(0)
      expect(calc_hourly.bonus_for(jake)).to eq(0)
    end

    it 'returns the percentage of worked hours / total worker hours of the fixed fee' do
      # 6 hours / 15 hours total = 0.4
      expect(calc_fixed.bonus_for(jim)).to eq(1400)
      expect(calc_fixed.bonus_for(john)).to eq(933.33)

      expect(calc_hourly.bonus_for(jill)).to eq(0)
      expect(calc_hourly.bonus_for(jake)).to eq(0)
    end
  end

  describe '#bonus_total' do
    it 'hourly return total bonus for all workers' do
      expect(calc_hourly.bonus_total).to eq(160)
    end

    it 'fixed returns total bonus for the project' do
      expect(calc_fixed.bonus_total).to eq(2333.33) # Employee's bonus.
    end
  end

  it '#total_for' do
    expect(calc_hourly.total_for(jim)).to eq(600) # Salary 100 x 5 + Bonus 100 = 600
    expect(calc_hourly.total_for(john)).to eq(660) # Salary 200 x 3 + Bonus 60 = 660
    expect(calc_hourly.total_for(jill)).to eq(0) # No salary or bonus.
    expect(calc_hourly.total_for(jake)).to eq(1600) # Fixed fee 400 x 4 = 1600

    expect(calc_fixed.total_for(jim)).to eq(1400)
    expect(calc_fixed.total_for(john)).to eq(933.33)
    expect(calc_fixed.total_for(jill)).to eq(0)
    expect(calc_fixed.total_for(jake)).to eq(2000)
  end

  it '#total' do
    expect(calc_hourly.total).to eq(2860) # 600 + 660 + 1600 = 2860
    expect(calc_fixed.total).to eq(4333.33) # Employee's bonus + Contractor fees.
  end
end
