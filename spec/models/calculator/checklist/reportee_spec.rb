require 'rails_helper'

RSpec.describe Calculator::Checklist::Reportee, type: :model do
  describe 'a checklist with 10000' do
    # 10K base amount, 4K is bonus to workers.
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
        @calculator = Calculator::Checklist::Reportee.new(checklist: paintjob, reportee: john)
      end

      describe '#payable_bonus_percentage' do
        it 'returns the bonus percentage that is accountable to pay' do
          expect(@calculator.payable_bonus_percentage).to eq(0.50)
        end
      end

      describe '#payable_bonus_amount' do
        it 'returns the bonus amount that is accountable for payment' do
          expect(@calculator.payable_bonus_amount).to eq(2000)
        end
      end
    end
  end
end
