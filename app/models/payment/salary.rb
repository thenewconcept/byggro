class Payment::Salary
  extend Memoist
  
  attr_accessor :from, :to
  attr_reader :reports

  BONUS_SALES = ENV['BONUS_SALES']&.to_f || 0.02

  def initialize(from: Time.zone.now.beginning_of_month, to: Time.zone.now.end_of_month)
    @from = from; @to = to;
  end

  def payable_hours
    payable_hourly_reports.sum(&:time_in_hours)
  end

  def payable_hourly_projects
    Project.where.not(bonus: 'fixed')
  end

  def payable_bonus_projects
    Project
      .where(bonus: 'fixed', completed_on: @from..@to)
      .or( Project.where( bonus: 'hourly', completed_on: @from..@to) )
      .status_completed
  end

  def sales_bonus_projects
    Project
      .where(payed_on: (@from - 2.months)..(@to - 2.months))
      .where.not(seller: [false, nil, ''])
  end

  def payable_hourly_reports
    Report
      .payable
      .where(reportable: payable_hourly_projects, reportee_type: ['Employee'], date: @from..@to)
      .or( 
        Report.payable.where(
          reportable: Checklist.where(project: payable_hourly_projects), 
          reportee_type: ['Employee'], date: @from..@to
        )
      )
  end

  def reportees
    payable_hourly_reports.map(&:reportee).uniq
  end

  memoize :payable_hours, 
    :payable_bonus_projects, 
    :payable_hourly_projects, 
    :sales_bonus_projects,
    :payable_hourly_reports,
    :reportees
end