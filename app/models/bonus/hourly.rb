class Bonus::Hourly
  attr_reader :project, :reportee

  def initialize(project, reportee)
    @project = project
    @reportee = reportee
  end

  def self.for(project, reportee)
    new(project, reportee)
  end
  
  def bonus_base
    reportee.salary 
  end

  def bonus_salary
    bonus_base * (1.0 - project.hourly_percent).round(2)
  end

  def bonus_amount
    bonus_salary * (Report.by_project(project).where(reportee: reportee).sum(:time_in_minutes) / 60)
  end
  
  def bonus_total
    bonus_amount * Report.where(reportee: reportee).sum(&:time_in_hours)
  end
end