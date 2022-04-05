class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
    @klass = eval("Bonus::#{project.bonus.capitalize}")
  end

  def self.for(project)
    new(project)
  end

  def hours_for(reportee)
    Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours)
  end

  def salary_for(reportee)
    @klass.for(project, reportee).salary
  end

  def bonus_for(reportee)
    @klass.for(project, reportee).bonus_amount
  end

  def bonus_percent(reportee=nil)
    @klass.for(project, reportee).bonus_percent
  end

  def bonus_total(reportee)
    @klass.for(project, reportee).salary_total
  end

  def salary_total_for(reportee)
    @klass.for(project, reportee).salary_total
  end

  def hourly_bonus_total
    Report.by_project(project).reduce(0) do |total, report|
      totalt = total + Bonus::Hourly.for(project, report.reportee).bonus_salary * report.time_in_hours
    end
  end

  def fixed_bonus_total
    project.bonus_fixed
  end
end