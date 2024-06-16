require 'rails_helper'

RSpec.describe Payroll, type: :model do
  before do
    # Users need to exists before processes to access the salary for the current log period.
    travel_to 1.month.ago do
      @john = create(:employee, salary: 200, title: 'John Painter')
      @jane = create(:employee, salary: 100, title: 'Jane Painter')
      @jim  = create(:employee, salary: 100, title: 'Jim Painter')
      @jake = create(:contractor, fee: 50)
      @jill = create(:intern)
    end

    @ongoing_project    = create(:project) # Ongoing by default.
    @completed_project  = create(:project, :completed, fixed_fee: 0.5)
    @unreported_project = create(:project, :completed)

    @ongoing_time_checklist    = create(:checklist, title: 'Ongoing Time', project: @ongoing_project, payout: :hourly)
    @ongoing_time_checklist    = create(:checklist, title: 'Ongoing Time', project: @ongoing_project, payout: :hourly)
    @ongoing_bonus_checklist   = create(:checklist, title: 'Ongoing Fixed', project: @ongoing_project, payout: :fixed, amount: 2000)
    @completed_time_checklist  = create(:checklist, title: 'Completed Time', project: @completed_project, payout: :hourly)
    @completed_bonus_checklist = create(:checklist, title: 'Completed Fixed', project: @completed_project, payout: :fixed, amount: 2000)
    @completed_bonus_checklist = create(:checklist, title: 'Completed Fixed', project: @completed_project, payout: :fixed, amount: 2000)

    # Old, range over 1 month.
    travel_to 1.month.ago do
      @old_report = create(:report, time_in_hours: 10, reportable: @ongoing_time_checklist, reportee: @jim)
      @completed_bonus_report_jane = create(:report, note: 'Completed bonus jane', time_in_hours: 6, reportable: @completed_bonus_checklist, reportee: @jane)
    end

     # Skipped, since it's not completed.
     @ongoing_bonus_report   = create(:report, note: 'Ongoing bonus', time_in_hours: 5, reportable: @ongoing_bonus_checklist, reportee: @jane)

    # Todays reports, range 1 day.

     # - Ongoing time reports.
     @ongoing_time_report_nopay   = create(:report, note: 'No pay', time_in_hours: 10, reportable: @ongoing_time_checklist, reportee: @john, payable: false)
     @ongoing_time_report_john    = create(:report, note: 'Ongoing hourly', time_in_hours: 10, reportable: @ongoing_time_checklist, reportee: @john)
     @ongoing_time_report_jake = create(:report, note: 'Ongoing hourly', time_in_hours: 10, reportable: @ongoing_time_checklist, reportee: @jake)
     @completed_time_report  = create(:report, note: 'Completed time', time_in_hours: 1, reportable: @completed_time_checklist, reportee: @jim)

     @completed_bonus_report_jill = create(:report, note: 'Completed bonus jill', time_in_hours: 10, reportable: @completed_bonus_checklist, reportee: @jill)
     @completed_bonus_report_john = create(:report, note: 'Completed bonus john', time_in_hours: 4, reportable: @completed_bonus_checklist, reportee: @john)
     @completed_bonus_report_jake = create(:report, note: 'Completed bonus jake', time_in_hours: 2, reportable: @completed_bonus_checklist, reportee: @jake)

    @payroll = Payroll.new(1.day.ago..1.day.from_now, create(:user, :admin))
  end

  it 'returns the payable reports for the given period' do
    expect(@payroll.reports).to match_array([ @ongoing_time_report_john, @completed_time_report, @completed_bonus_report_jane, @completed_bonus_report_john ]) 
    long_payroll  = Payroll.new(1.year.ago..1.day.from_now, create(:user, :admin))
    expect(long_payroll.reports).to match_array([ @old_report, @ongoing_time_report_john, @completed_time_report, @completed_bonus_report_jane, @completed_bonus_report_john]) 
  end

  it 'returns reports only allowed by the user' do
    payroll  = Payroll.new(1.year.ago..1.day.from_now, @jim.user)
    expect(payroll.reports).to match_array([ @old_report, @completed_time_report ]) 
  end

  it 'returns the payroll total for given range' do
    expect(@payroll.total).to eq(3050)
  end

  it 'returns the payroll workers' do
    expect(@payroll.workers).to match_array([@john, @jane, @jim])

    old_payroll = Payroll.new(2.months.ago..2.days.ago, create(:user, :admin))
    expect(old_payroll.workers).to match_array([@jim])
  end

  it 'returns the payroll projects' do
    expect(@payroll.projects).to match_array([@ongoing_project, @completed_project])
  end

  it 'returns the payroll checklists' do
    expect(@payroll.checklists).to match_array([
      @ongoing_time_checklist, 
      @completed_time_checklist, 
      @completed_bonus_checklist
    ])
  end

  it 'returns a set of payments' do
    expect(@payroll.payments.count).to eq(4)

      # - Completed bonus reports. 2000 (Reportable amount) - 100 (@jake, contractor) = 1900 total.
      # - Fixed bonus is 50% of the total amount, so 950 for each worker.
      # - @john 40% of 950 = 380, @jane 60% of 950 = 570.

    # Sort is report date DESC, so last reportee first.
    # 1. - Fixed john and jane.
    expect(@payroll.payments.first.reportee).to eq(@john)
    expect(@payroll.payments.first.total).to eq(380)

    expect(@payroll.payments[1].reportee).to eq(@jane)
    expect(@payroll.payments[1].total).to eq(570)

    # 2. - Hours for Jim.
    expect(@payroll.payments[2].reportee).to eq(@jim)
    expect(@payroll.payments[2].total).to eq(100)

    # 3. - Hours for John.
    expect(@payroll.payments.last.reportee).to eq(@john)
    expect(@payroll.payments.last.total).to eq(2000)
  end
end