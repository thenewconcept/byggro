class Checklist < ApplicationRecord
  include Bonusable
  acts_as_list scope: :project
  before_destroy :destroyable?

  belongs_to :project
  validates :title, presence: true

  has_many :reports, as: :reportable, dependent: :destroy
  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 

  delegate :status_completed?, :fixed_fee, :hourly_rate, to: :project

  def employee_reports
    reports.where(reportee_type: ['Employee'])
  end

  def worker_reports
    reports.where(reportee_type: ['Employee', 'Contractor'])
  end

  def completed?
    todos.all?(&:completed?)
  end

  def hours_reported
    Report.by_checklist(self).sum(&:time_in_hours)&.round(2)
  end

  def hours_estimated
    hours_target.round(0)
  end

  private
  def destroyable?
    if self.reports.present?
      self.errors.add(:base, "Kan inte ta bort lista med rapporter.")
      throw :abort
    end
  end
end
