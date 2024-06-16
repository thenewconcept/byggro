class Payroll::Hourly
  attr_reader :reportee, :reportable

  def initialize(reportee, reports)
    @reportee = reportee
    @reports = reports
  end

  def reportable
    @reports.first.reportable
  end

  def time_in_hours
    @reports.sum(&:time_in_hours)
  end

  def total
    @reports.sum(&:total)
  end
end