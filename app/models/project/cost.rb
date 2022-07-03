class Project::Cost
  attr_reader :project
  def initialize(project)
    @project = project
  end

  def expenses
    project.expenses.sum(&:amount)
  end

  def salaries
    return 0 if project.bonus_fixed?
    project.reports.by_reportees('Employee').sum(&:total)
  end

  def bonuses
    Bonus::Calculator.for(project).bonus_total
  end

  def salaries_including_bonuses
    salaries + bonuses
  end

  def fees
    project.reports.by_reportees('Contractor').sum(&:total)
  end

  def taxes
    (salaries_including_bonuses * 0.32) + (salaries_including_bonuses * 0.12).round(2)
  end

  def total
    expenses + salaries + bonuses + fees + taxes
  end
end