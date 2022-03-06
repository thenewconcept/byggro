require 'rails_helper'

RSpec.describe Bonus::Calculator do
  let(:hourly_project)  { create(:project, hourly_rate: 500, bonus: :hourly) }
  let(:fixed_project)   { create(:project, bonus: :fixed) }

  let!(:checklist1) { create(:checklist, amount: 10000, project: hourly_project) }
  let!(:checklist2) { create(:checklist, amount: 10000, project: fixed_project) }

  let(:john)      { create(:worker, salary: 200) }
  let(:jim)       { create(:worker, salary: 100) }

  let(:calc_hourly) { Bonus::Calculator.for(hourly_project) }
  let(:calc_fixed)  { Bonus::Calculator.for(fixed_project) }

  before do
    create(:report, time_in_minutes: 300, checklist: checklist1, worker: john)
    create(:report, time_in_minutes: 300, checklist: checklist1, worker: jim)

    create(:report, time_in_minutes: 300, checklist: checklist2, worker: john)
    create(:report, time_in_minutes: 300, checklist: checklist2, worker: jim)
  end

  it '#hourly_bonus_total' do
    expect(calc_hourly.hourly_bonus_total).to eq(750)
  end

  it '#fixed_bonus_total' do
    expect(calc_fixed.fixed_bonus_total).to eq(3500)
  end

  it '#bonus_total' do
    expect(calc_hourly.bonus_total).to eq(750)
    expect(calc_fixed.bonus_total).to eq(3500)
  end

  it '#bonus_for' do
    expect(calc_hourly.bonus_for(jim)).to eq(500)
    expect(calc_hourly.bonus_for(john)).to eq(250)

    expect(calc_fixed.bonus_for(jim)).to eq(1750)
    expect(calc_fixed.bonus_for(john)).to eq(1750)
  end
end
