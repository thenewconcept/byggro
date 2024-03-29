class Bonus::Hourly
  BONUS_INDEX = ENV['BONUS_INDEX']&.to_i || 300
  attr_reader :project, :reportee, :hours

  def initialize(project, reportee)
    @project  = project
    @reportee = reportee
    @hours    = project.reports.where(reportee: reportee).sum(&:time_in_hours)
  end

  def self.for(project, reportee)
    new(project, reportee)
  end

  def bonus_base(salary)
    [(BONUS_INDEX - salary), salary].min
  end

  def bonus_salary(salary)
    [(bonus_base(salary) * bonus_percent), 0].max
  end

  def salary
    scope = project.reports
    scope = scope.where(reportee: reportee) if reportee
    salary ||= scope.sum { |report| report.fee * report.time_in_hours }
  end

  def bonus_total
    project.workers.sum { |worker| Bonus::Hourly.for(project, worker).bonus }
  end

  def bonus_percent
    (1.0 - project.hourly_percent).round(2)
  end
  
  def bonus_for_report(report)
    [bonus_base_for_report(report) * bonus_percent * report.time_in_hours, 0].max
  end

  def bonus_base_for_report(report)
    [(BONUS_INDEX - report.fee), report.fee].min
  end
  
  def bonus
    return 0 if reportee.is_a?(Contractor) \
    or reportee.is_a?(Intern) \
    or (project.hours_reported > project.hours_estimated)

    scope = project.reports.where(reportee_type: ['Employee'])
    scope = scope.where(reportee: reportee) if reportee

    bonus ||= scope.sum do |report| 
      bonus_base_for_report(report) * bonus_percent * report.time_in_hours
    end
  end

  def total
    bonus + salary
  end
end