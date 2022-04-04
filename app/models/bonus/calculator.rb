class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
    @klass = eval("Bonus::#{project.bonus.capitalize}")
  end

  def self.for(project)
    new(project)
  end

  def salary_for(reportee)
    @klass.for(project, reportee).salary
  end

  def bonus_for(reportee)
    @klass.for(project, reportee).bonus_amount
  end

  def bonus_percent(reportee=nil)
    public_send("#{project.bonus}_bonus_percent", reportee)
  end

  def bonus_total(reportee)
    public_send("#{project.bonus}_salary_total_for", reportee)
  end

  def salary_total_for(reportee)
    public_send("#{project.bonus}_salary_total_for", reportee)
  end

  def hourly_salary_total_for(reportee)
    @klass.for(project, reportee).salary_total
  end

  def fixed_salary_total_for(reportee)
    @klass.for(project, reportee).salary_total
  end

  def hourly_bonus_percent(reportee)
    @klass.for(project, reportee).bonus_percent
  end

  def fixed_bonus_percent(reportee)
    @klass.for(project, reportee).bonus_percent
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