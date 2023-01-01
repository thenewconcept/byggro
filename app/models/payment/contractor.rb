class Payment::Contractor
  def initialize(from: Time.zone.now.beginning_of_month, to: Time.zone.now.end_of_month)
    @from = from; @to = to;
  end

  def payable_hours
    @payable_hours ||= payable_reports.sum(&:time_in_hours)
  end

  def payable_reports
    @payable_reports ||= Report
      .payable
      .where(reportee_type: 'Contractor', date: @from..@to)
  end

  def reportees
    payable_reports.map(&:reportee).uniq
  end
end