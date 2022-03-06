class Bonus::Fixed
  BASE = ENV['FIXED_BASE']&.to_f || 0.35
  attr_reader :project, :worker, :total_bonus, :total_hours

  def initialize(project, worker)
    @project = project
    @worker  = worker

    @total_bonus  = project.bonus_fixed
    @total_hours  = project.hours_reported
  end

  def self.for(project, worker)
    new(project, worker)
  end
  
  def worker_hours
    project.reports.where(worker: worker).sum(:time_in_minutes).to_f / 60
  end

  def worker_percentage
    worker_percentage = worker_hours / total_hours
  end

  def bonus_total
    total_bonus * worker_percentage
  end
end