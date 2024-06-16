class Checklist < ApplicationRecord
  include Bonusable
  include Reportable

  acts_as_list scope: :project

  enum bonus: [ :none, :fixed ], _prefix: true

  belongs_to :project
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 

  before_destroy :destroyable?
  validates :title, presence: true

  delegate :status_completed?, :fixed_fee, to: :project

  def completed?
    todos.all?(&:completed?)
  end

  def hours_reported
    Report.by_checklist(self).sum(&:time_in_hours)&.round(2)
  end

  def hours_estimated
    hours_target.round(0)
  end

  def hours_reported
    case bonus
    when "none" then reports.sum(&:time_in_hours)&.round(2)
    when "fixed" then amount / HOURLY_RATE
    end
  end

  def revenue
    case self.bonus
      when 'none'
        reports.sum(&:time_in_hours) * hourly_rate
      when 'fixed'
        amount
      else
        raise 'Unknown bonus type'
    end
  end

  def salary
    case self.bonus
      when 'none'
        reports.where.not( reportee_type: 'Contractor' ).sum(&:total)
      when 'fixed'
        amount * project.fixed_fee
      else
        raise 'Unknown bonus type'
    end
  end

  def completed?
    todos.all?(&:completed?)
  end

  private

  def destroyable?
    if self.reports.present?
      self.errors.add(:base, "Kan inte ta bort lista med rapporter.")
      throw :abort
    end
  end
end
