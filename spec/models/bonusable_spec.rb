require 'rails_helper'

RSpec.describe Bonusable, type: :module do
  describe '#bonus_fixed' do
    it 'return the fixed bonus percentage' do
      model = create(:project, fixed_fee: 0.5)
      create(:checklist, project: model, amount: 1000)
      expect(model.bonus_fixed).to eq(500)
    end
  end
  it '#hours_target' do
    model = create(:project, hourly_rate: 100)
    create(:checklist, project: model, amount: 1000)
    expect(model.hours_target).to eq 10
  end

  it '#hours_target' do
    model = create(:project, hourly_rate: 0)
    expect(model.hours_target).to eq 0
  end

  it '#hours_target' do
    model = create(:project, hourly_rate: 0)
    create(:checklist, project: model, amount: 1000)
    expect(model.hours_target).to eq 0
  end
end