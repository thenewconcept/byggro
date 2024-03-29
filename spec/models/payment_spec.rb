require 'rails_helper'

RSpec.describe 'Payments' do
  before do
    travel_to(Time.parse('2019-10-01'))

    @employee = create(:employee)
    @intern   = create(:intern)
    @contractor = create(:contractor)

    travel_back
  end
  
  # Projects
  let(:ongoing_hourly) { create(:project, :none) }
  let(:ongoing_fixed)  { create(:project, :fixed) }
  let(:ongoing_bonus)  { create(:project, :hourly) }
  let(:finished_fixed)  { create(:project, :fixed, status: 'completed', completed_on: '2020-02-01') }

  # Reports for an hourly projects
  let!(:contractor_report) { create(:report, reportable: ongoing_hourly, reportee: @contractor, date: '2020-01-03', time_in_hours: 5) }
  let!(:intern_report)     { create(:report, reportable: ongoing_hourly, reportee: @intern, date: '2020-01-02', time_in_hours: 5) }
  let!(:employee_report)   { create(:report, reportable: ongoing_hourly, reportee: @employee, date: '2020-01-05', time_in_hours: 5) }

  let!(:employee_report_bonus)   { create(:report, reportable: ongoing_bonus, reportee: @employee, date: '2020-01-01', time_in_hours: 5) }
  let!(:contractor_report_bonus)   { create(:report, reportable: ongoing_bonus, reportee: @contractor, date: '2020-01-05', time_in_hours: 5) }

  # Reports for bonus projects
  let!(:february_report)  { create(:report, reportable: ongoing_hourly, reportee: @employee, date: '2020-02-03', time_in_hours: 5) }
  let!(:fixed_report)  { create(:report, reportable: finished_fixed, reportee: @employee, date: '2020-02-05', time_in_hours: 5) }

  # Reports for fixed projects
  let!(:non_payable_fixed_report) { create(:report, reportable: ongoing_fixed, reportee: @employee, date: '2020-01-03', time_in_hours: 5) } 

  describe 'salaries for january' do
    subject { Payment::Salary.new(from: '2020-01-01', to: '2020-01-31') }

    it 'returns payable hourly reports a period' do
      expect(subject.payable_hourly_reports).to include(employee_report, employee_report_bonus)
      expect(subject.payable_hourly_reports).to_not include(non_payable_fixed_report, february_report, intern_report, contractor_report, contractor_report_bonus)
    end

    it 'returns payable projects' do
      expect(subject.payable_hourly_projects).to include(ongoing_hourly, ongoing_bonus)
      expect(subject.payable_bonus_projects).to_not include(finished_fixed)
    end

    it 'returns the payable hours' do
      expect(subject.payable_hours).to eq(10)
    end

    it 'returns reportees to pay for a period' do
      expect(subject.reportees).to include(@employee)
      expect(subject.reportees).to_not include(@intern, @contractor)
    end
  end

  describe 'contractors for january' do
    subject { Payment::Contractor.new(from: '2020-01-01', to: '2020-01-31') }

    it 'returns the payable hours' do
      expect(subject.payable_hours).to eq(10)
    end

    it 'returns contractors to pay for a period' do
      expect(subject.reportees).to include(@contractor)
      expect(subject.reportees).to_not include(@intern, @employee)
    end
  end

  describe 'salary for february' do
    subject { Payment::Salary.new(from: '2020-02-01', to: '2020-02-28') }
    it 'scopes appropiatly' do
      expect(subject.reportees).to eq([@employee])
      expect(subject.payable_hours).to eq(5)
      expect(subject.payable_hourly_reports).to eq([february_report])
      expect(subject.payable_bonus_projects).to eq([finished_fixed])
    end


    it 'catches new completed projects' do
      ongoing_bonus.update(status: 'completed', completed_on: '2020-02-28')
      payment = Payment::Salary.new(from: '2020-02-01', to: '2020-02-28')
      expect(payment.payable_bonus_projects).to eq([finished_fixed, ongoing_bonus])
    end
  end
end