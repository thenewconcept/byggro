require 'rails_helper'

RSpec.describe Bonus::Calculator do
  let(:normal_project)  { create(:project, hourly_rate: 500, bonus: :none) }
  let(:hourly_project)  { create(:project, hourly_rate: 500, bonus: :hourly) }
  let(:fixed_project)   { create(:project, bonus: :fixed) }

  let!(:normal_checklist) { create(:checklist, amount: 10000, project: normal_project) }
  let!(:hourly_checklist) { create(:checklist, amount: 10000, project: hourly_project) }
  let!(:fixed_checklist)  { create(:checklist, amount: 10000, project: fixed_project) }

  let(:john)      { create(:employee, salary: 200) }
  let(:jim)       { create(:employee, salary: 100) }

  let(:calc_normal) { Bonus::Calculator.for(normal_project) }
  let(:calc_hourly) { Bonus::Calculator.for(hourly_project) }
  let(:calc_fixed)  { Bonus::Calculator.for(fixed_project) }

  before do
    # Hourly project has an hourly target of 20 hours
    create(:report, time_in_hours: 5, reportable: hourly_checklist, reportee: john)
    create(:report, time_in_hours: 5, reportable: hourly_checklist, reportee: jim)

    # Fixed project has an project salary of 3500
    create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: john)
    create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: jim)
  end

  describe '#none_bonus_percent' do
    it 'returns 0' do
      expect(calc_normal.bonus_percent(john)).to eq(0)
    end
  end

  describe '#hourly_bonus_percent' do
    it 'returns 25% for the hourly bonus' do
      create(:report, time_in_hours: 5, reportable: hourly_checklist, reportee: john)
      expect(calc_hourly.bonus_percent(john)).to eq(0.25)
    end
  end

  describe '#fixed_bonus_percent' do
    it 'returns %-portion of total hours' do
      create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: john)
      expect(calc_fixed.bonus_percent(john)).to be_within(0.01).of(0.66)
      expect(calc_fixed.bonus_percent(jim)).to be_within(0.01).of(0.33)
    end
  end

  describe '#[klass]_bonus_total' do
    it '[hourly] return total bonus for all workers' do
      expect(calc_hourly.hourly_bonus_total).to eq(750)
    end

    it '[fixed] returns total bonus for the project' do
      expect(calc_fixed.fixed_bonus_total).to eq(3500)
    end
  end

  it '#bonus_total' do
    expect(calc_hourly.bonus_total(jim)).to eq(750)
    expect(calc_hourly.bonus_total(john)).to eq(1500)

    expect(calc_fixed.bonus_total(jim)).to eq(1750)
    expect(calc_fixed.bonus_total(john)).to eq(1750)
  end

  it '#bonus_for' do
    expect(calc_hourly.bonus_for(jim)).to eq(250)
    expect(calc_hourly.bonus_for(john)).to eq(500)

    expect(calc_fixed.bonus_for(jim)).to eq(1750)
    expect(calc_fixed.bonus_for(john)).to eq(1750)
  end

  it '#salary_total_for' do
    expect(calc_hourly.salary_total_for(jim)).to eq(750)
    expect(calc_hourly.salary_total_for(john)).to eq(1500)

    create(:report, time_in_hours: 5, reportable: fixed_checklist, reportee: john)
    expect(calc_fixed.salary_total_for(jim)).to be_within(0.1).of(1166.6)
    expect(calc_fixed.salary_total_for(john)).to be_within(0.1).of(2333.3)
  end
end
