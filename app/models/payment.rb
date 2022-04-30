class Payment
  attr_accessor :from, :to
  attr_reader :reports

  def initialize(from: Time.zone.now.beginning_of_month, to: Time.zone.now.end_of_month)
    @from = from; @to = to;
  end

  def payable_hours
    @payable_hours ||= payable_hourly_reports.sum(&:time_in_hours)
  end

  def payable_hourly_projects
    @payable_hourly_projects ||= Project.where.not(bonus: 'fixed')
  end

  def payable_bonus_projects
    @payable_bonus_projects ||= Project.where(bonus: 'fixed').or(Project.where(bonus: 'hourly')).status_completed
  end

  def payable_hourly_reports
    @payable_hourly_reports ||= Report.where(date: @from..@to)
      .where(reportable: payable_hourly_projects, reportee_type: ['Employee', 'Contractor'])
      .or( Report.where(reportable: Checklist.where(project: payable_hourly_projects), reportee_type: ['Employee', 'Contractor']) )
  end

  def reportees
    @reportees ||= payable_hourly_reports.map(&:reportee).uniq
  end
end