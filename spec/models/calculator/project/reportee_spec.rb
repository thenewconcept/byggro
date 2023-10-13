require 'rails_helper'

RSpec.describe Calculator::Project::Reportee, type: :model do
  describe 'a Project with 20000' do
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
        @johns_calculator = Calculator::Project::Reportee.new(project: project, reportee: john)
        @jims_calculator = Calculator::Project::Reportee.new(project: project, reportee: jim)
      end

      describe '#payable_bonus_amount' do
        # John gets 2000 for the paintjob, and 2240 for carpentry
        it 'returns the bonus amount that is accountable for payment' do
          expect(@johns_calculator.payable_bonus_amount).to eq(4400)
          expect(@jims_calculator.payable_bonus_amount).to eq(2600)
        end
      end
    end
  end
end
