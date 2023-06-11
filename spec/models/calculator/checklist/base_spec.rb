require 'rails_helper'

RSpec.describe Calculator::Checklist::Base, type: :model do
  describe 'a checklist with 10000' do
    let(:project)   { create(:project, hourly_rate: 500, fixed_fee: 0.40) }
    let(:paintjob)  { create(:checklist, amount: 10000, project: project) }

    let(:john)    { create(:employee) }
    let(:jim)     { create(:employee) }
    let(:jill)    { create(:intern) }
    let(:jake)    { create(:contractor, fee: 500) }
    
    before do
      create(:report, time_in_hours: 10, reportable: paintjob, reportee: john) # 50%
      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jim) # 25%
      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jake) # 25%
      create(:report, time_in_hours: 5, reportable: paintjob, reportee: jill) # Not accounted for.
    end

    context 'using a checklist' do
      before do
        @calculator = Calculator::Checklist::Base.new(paintjob)
      end

      describe '#new' do
        it 'sets default values' do
          expect(@calculator.total_hours).to eq(25)
          expect(@calculator.total_bonus).to eq(4000)
        end
      end

      describe '#accountable_hours' do
        it 'returns hours that accounts for the bonus, i.e. employees and contractors' do
          expect(@calculator.accountable_hours).to eq(20)
        end
      end

      describe '#payable_hours' do
        it 'returns the hours to pay bonus for, i.e. employees' do
          expect(@calculator.payable_hours).to eq(15)
        end
      end

      describe '#payable_bonus_percentage' do
        it 'returns the bonus percentage that is accountable to pay' do
          expect(@calculator.payable_bonus_percentage).to eq(0.75)
        end
      end

      describe '#payable_bonus_amount' do
        it 'returns the bonus amount that is accountable for payment' do
          expect(@calculator.payable_bonus_amount).to eq(3000)
        end
      end
    end
  end
end
