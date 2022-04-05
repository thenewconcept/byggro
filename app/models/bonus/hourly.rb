class Bonus::Hourly
  attr_reader :project, :reportee, :hours

  def initialize(project, reportee)
    @project  = project
    @reportee = reportee
    @hours    = Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours)
  end

  def self.for(project, reportee)
    new(project, reportee)
  end

  def salary
    reportee.salary * (Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours))
  end

  def bonus_total
    project.workers.reduce(0) do |sum, worker|
      sum += Bonus::Hourly.for(project, worker).bonus
    end
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

  def bonus
    bonus_salary * (hours)
  end

  def total
    bonus + (hours * reportee.salary)
  end
end