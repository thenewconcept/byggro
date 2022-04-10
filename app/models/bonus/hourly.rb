class Bonus::Hourly
  INDEX = ENV['BONUS_INDEX'] || 300
  attr_reader :project, :reportee, :hours

  def initialize(project, reportee)
    @project  = project
    @reportee = reportee
    @hours    = Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours)
  end

  def self.for(project, reportee)
    new(project, reportee)
  end

  # TODO: Move these to a separate concern, not attached to a reportee
  def bonus_base(salary)
    [(INDEX - salary), salary].min
  end

  def bonus_salary(salary)
    bonus_base(salary) * bonus_percent
  end

  # TODO END

  def salary
    salary ||= Report.by_project(project).where(reportee: reportee).sum do |report| 
      report.fee * report.time_in_hours
    end
  end

  def bonus_total
    project.workers.sum do |worker|
      Bonus::Hourly.for(project, worker).bonus
    end
  end

  def bonus_percent
    (1.0 - project.hourly_percent)
  end
  
  def bonus_for_report(report)
    [(INDEX - report.fee), report.fee].min * bonus_percent * report.time_in_hours
  end
  
  def bonus
    bonus ||= Report.by_project(project).where(reportee: reportee).sum do |report| 
      [(INDEX - report.fee), report.fee].min * bonus_percent * report.time_in_hours
    end
  end

  def total
    bonus + salary
  end
end