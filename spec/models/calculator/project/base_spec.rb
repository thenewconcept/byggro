require 'rails_helper'

RSpec.describe Calculator::Project::Base, type: :model do
  describe 'a project with total with 20000' do
    let(:project)   { create(:project, hourly_rate: 500, fixed_fee: 0.40) }
    let(:paintjob)  { create(:checklist, amount: 10000, project: project) }
    let(:carpentry)  { create(:checklist, amount: 10000, project: project) }

    let(:john)    { create(:employee) }
    let(:jim)     { create(:employee) }
    let(:jill)    { create(:intern) }
    let(:jake)    { create(:contractor, fee: 500) }
    
    before do
      create(:report, time_in_hours: 10, reportable: paintjob, reportee: john) # 50%
      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jim) # 25%

      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jake) # 25%, accounted not payable.
      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jill) # Not accounted for.

      create(:report, time_in_hours: 6, reportable: carpentry, reportee: john) # 60%
      create(:report, time_in_hours: 4, reportable: carpentry, reportee: jim) # 40%
    end

    context 'using a checklist' do
      before do
        @calculator = Calculator::Project::Base.new(project)
      end

      describe '#new' do
        it 'sets default values' do
          expect(@calculator.total_hours).to eq(35)
          expect(@calculator.total_bonus).to eq(8000)
        end
      end

      describe '#accountable_hours' do
        it 'returns hours that accounts for the bonus, including employees and contractors' do
          expect(@calculator.accountable_hours).to eq(30)
        end
      end

      describe '#payable_hours' do
        it 'returns the hours to pay bonus for, excluding contractors' do
          expect(@calculator.payable_hours).to eq(25)
        end
      end

      describe '#payable_bonus_percentage' do
        it 'returns the bonus percentage that is accountable to pay' do
          expect(@calculator.payable_bonus_percentage).to be_within(0.01).of(0.83)
        end
      end

      describe '#payable_bonus_amount' do
        it 'returns the bonus amount that is accountable for payment' do
          expect(@calculator.payable_bonus_amount).to eq(7000)
        end
      end
    end
  end
end
