class Project::Cost
  attr_reader :project
  def initialize(project)
    @project = project
  end

  def bonuses
    Bonus::Calculator.for(project).bonus_total
  end

  def expenses
    project.expenses.sum(&:amount)
  end

  def salaries
    Report.by_project(project).by_reportees('Employee').sum(&:total)
  end

  def fees
    Report.by_project(project).by_reportees('Contractor').sum(&:total)
  end

  def taxes
    (salaries * 1.32 * 1.12).round(2)
  end

  def total
    expenses + salaries + bonuses + fees + taxes
  end
end