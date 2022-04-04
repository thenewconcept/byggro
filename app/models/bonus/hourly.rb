class Bonus::Hourly
  attr_reader :project, :reportee

  def initialize(project, reportee)
    @project = project
    @reportee = reportee
  end

  def self.for(project, reportee)
    new(project, reportee)
  end

  def salary
    reportee.salary * (Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours))
  end

  def bonus_percent
    (1.0 - project.hourly_percent)
  end
  
  def bonus_base
    reportee.salary 
  end

  def bonus_salary
    bonus_base * bonus_percent
  end

  def bonus_amount
    bonus_salary * (Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours))
  end
  
  def salary_total
    bonus_amount + (Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours) * reportee.salary)
  end
end