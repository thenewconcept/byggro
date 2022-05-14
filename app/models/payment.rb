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
    @payable_bonus_projects ||= Project.where(bonus: 'fixed', completed_at: @from..@to).or(Project.where(bonus: 'hourly', completed_at: @from..@to)).status_completed
  end

  def payable_hourly_reports
    @payable_hourly_reports ||= Report
      .where(reportable: payable_hourly_projects, reportee_type: ['Employee'], date: @from..@to)
      .or( Report.where(reportable: Checklist.where(project: payable_hourly_projects), reportee_type: ['Employee'], date: @from..@to) )
      .or( Report.where(reportee_type: 'Contractor', date: @from..@to) )
  end

  def reportees
    @reportees ||= payable_hourly_reports.map(&:reportee).uniq
  end
end