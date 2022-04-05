class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
    @klass = eval("Bonus::#{project.bonus.capitalize}")
  end

  def self.for(project)
    new(project)
  end

  def bonus_percent(reportee=nil)
    @klass.for(project, reportee).bonus_percent
  end

  def hours_for(reportee)
    Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours)
  end

  def salary_for(reportee)
    @klass.for(project, reportee).salary
  end

  def bonus_for(reportee)
    @klass.for(project, reportee).bonus
  end

  def bonus_total
    @klass.for(project, nil).bonus_total
  end

  def total_for(reportee)
    @klass.for(project, reportee).total
  end
end