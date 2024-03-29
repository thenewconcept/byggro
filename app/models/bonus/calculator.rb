class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
    @klass = eval("Bonus::#{project.bonus.capitalize}")
  end

  def self.for(project)
    new(project)
  end

  def bonus_salary(salary)
    @klass.for(project, nil).bonus_salary(salary)
  end

  def bonus_base(salary)
    @klass.for(project, nil).bonus_base(salary)
  end

  def bonus_percent(reportee=nil)
    @klass.for(project, reportee).bonus_percent.round(2)
  end

  def hours_for(reportee)
    project.reports.where(reportee: reportee).sum(&:time_in_hours)
  end

  def salary_for(reportee)
    @klass.for(project, reportee).salary
  end

  def bonus_for_report(report)
    @klass.for(project, report.reportee).bonus_for_report(report)
  end

  def bonus_for(reportee)
    @klass.for(project, reportee).bonus.round(2)
  end

  def bonus_total
    @klass.for(project, nil).bonus_total.round(2)
  end

  def total_for(reportee)
    @klass.for(project, reportee).total.round(2)
  end

  def total
    @klass.for(project, nil).total.round(2)
  end
end