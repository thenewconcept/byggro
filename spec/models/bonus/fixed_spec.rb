require 'rails_helper'

RSpec.describe Bonus::Fixed, type: :model do
  describe 'a project with 10000' do

    let(:project)   { create(:project, hourly_rate: 500, fixed_fee: 0.30) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }

    let(:john)    { create(:employee) }
    let(:jim)     { create(:employee) }
    let(:jill)    { create(:intern) }
    let(:jake)    { create(:contractor, fee: 500) }
    
    before do
      create(:report, time_in_hours: 10, reportable: checklist, reportee: john) # 50%
      create(:report, time_in_hours: 5, reportable: checklist, reportee: jim) # 25%
      create(:report, time_in_hours: 5, reportable: checklist, reportee: jake) # 25%
      create(:report, time_in_hours: 5, reportable: checklist, reportee: jill) # Not accounted for.
    end

    describe '#employee_hours' do
      it 'returns hours worked by employee' do
        expect(Bonus::Fixed.for(project, john).worker_hours).to eq(10)
        expect(Bonus::Fixed.for(project, jim).worker_hours).to eq(5)
      end
    end

    describe '#bonus_percent' do
      it 'returns hours worked by employee' do
        expect(Bonus::Fixed.for(project, john).bonus_percent).to eq(0.50)
        expect(Bonus::Fixed.for(project, jim).bonus_percent).to eq(0.25)
        expect(Bonus::Fixed.for(project, jake).bonus_percent).to eq(0.25)
        expect(Bonus::Fixed.for(project, jill).bonus_percent).to eq(0.0)
      end

      it 'returns the project payable bonus percent' do
        expect(Bonus::Fixed.for(project, nil).bonus_percent).to eq(0.75)
      end

      it 'handles zero division' do
        unreported_project = create(:project) # Implies zero reported hours
        expect(Bonus::Fixed.for(unreported_project, nil).bonus_percent).to eq(0.0)
      end
    end

    describe '#bonus_total' do
      it 'returns the bonus total' do
        expect(Bonus::Fixed.for(project, nil).bonus_total).to eq(2250)
      end
    end

    describe '#bonus' do
      it 'returns reportee salary expenses' do
        expect(Bonus::Fixed.for(project, john).bonus).to eq(1500)
        expect(Bonus::Fixed.for(project, jim).bonus).to eq(750)
        expect(Bonus::Fixed.for(project, jill).bonus).to eq(0)
        expect(Bonus::Fixed.for(project, jake).bonus).to eq(0)
      end

      it 'returns project bonus total' do
        expect(Bonus::Fixed.for(project, nil).bonus).to eq(2250)
      end
    end

    describe '#total' do
      it 'returns reportee salary expenses' do
        expect(Bonus::Fixed.for(project, john).total).to eq(1500)
        expect(Bonus::Fixed.for(project, jim).total).to eq(750)
        expect(Bonus::Fixed.for(project, jill).total).to eq(0)
        expect(Bonus::Fixed.for(project, jake).total).to eq(2500)
      end

      it 'returns project total' do
        expect(Bonus::Fixed.for(project, nil).total).to eq(4750)
      end
    end

    describe '#salary' do
      it 'returns reportee salary expenses' do
        expect(Bonus::Fixed.for(project, john).salary).to eq(0)
        expect(Bonus::Fixed.for(project, jim).salary).to eq(0)
        expect(Bonus::Fixed.for(project, jill).salary).to eq(0)
        expect(Bonus::Fixed.for(project, jake).salary).to eq(2500)
      end

      it 'returns project total' do
        expect(Bonus::Fixed.for(project, nil).salary).to eq(2500)
      end
    end
  end
end
