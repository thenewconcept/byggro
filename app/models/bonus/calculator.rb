class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def self.for(project)
    new(project)
  end

  def bonus_for(worker)
    _class = eval("Bonus::#{project.bonus.capitalize}")
    _class.for(project, worker).bonus_total
  end

  def bonus_total
    public_send("#{project.bonus}_bonus_total")
  end

  def hourly_bonus_total
    project.reports.reduce(0) do |total, report|
      totalt = total + Bonus::Hourly.for(project, report.worker).bonus_salary * report.time_in_hours
    end
  end

  def fixed_bonus_total
    project.bonus_fixed
  end
end