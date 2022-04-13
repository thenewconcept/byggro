class Project < ApplicationRecord
  include Bonusable

  BONUS_FIXED = ENV['BONUS_FIXED']&.to_f || 0.30
  HOURLY_RATE = ENV['HOURLY_RATE']&.to_i || 500
  ROT_PERCENT = ENV['ROT_PERCENT']&.to_f || 0.3
  TARGET_MARGIN = ENV['TARGET_MARGIN']&.to_f || 0.2

  enum bonus: [ :none, :hourly, :fixed ], _prefix: true
  enum status: { draft: 'draft', upcoming: 'upcoming', started: 'started', completed: 'completed' }, _prefix: true

  validates :material_amount, :misc_amount, numericality: true

  after_create :generate_checklists
  before_save  :defaults

  has_rich_text :description
  has_many :checklists, dependent: :destroy
  has_many :todos, through: :checklists
  has_many :reports, as: :reportable, dependent: :destroy

  has_many :assignments
  has_many :users, through: :assignments

  def reports
    @reports ||= Report.by_project(self)
  end

  def workers
    reports.where.not(reportee_type: 'contractor').map(&:reportee).uniq
  end

  def reportees
    reports.map(&:reportee).uniq
  end

  def primary_date
    starts_at.present? ?  starts_at : created_at.to_date
  end

  def hours_estimated
    checklists&.sum(&:hours_target)&.round(0)
  end

  def hours_reported
    Report.by_project(self).sum(&:time_in_hours)
  end

  def hours_by_interns
    reports.where(reportee_type: 'Intern').sum(&:time_in_hours)
  end

  def hours_for(reportee)
    Report.where(reportee: reportee).sum(&:time_in_hours)
  end

  def amount
    checklists&.sum(&:amount)
  end

  def total
    [amount, material_amount, misc_amount].sum
  end

  def expenses
    material_amount * 0.20
  end

  def rot
    inc_vat(amount) * ROT_PERCENT
  end

  def client_costs
    client_payed + rot
  end

  def client_payed
    inc_vat(total) - rot - inc_vat(material_amount)
  end

  def vat(amount)
    amount * 0.25
  end

  def inc_vat(amount)
    amount + vat(amount)
  end

  def is_bonusable?
    bonus_fixed? or bonus_hourly?
  end

  private

  def defaults
    self.fixed_fee   ||= BONUS_FIXED
    self.hourly_rate ||= HOURLY_RATE
  end

  def generate_checklists
    self.checklists.create(title: 'Arbetsorder')
  end
end
