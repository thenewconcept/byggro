class Project < ApplicationRecord
  include Bonusable

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

  def workers
    Report.by_project(self).where.not(reportee_type: 'Contractor').map(&:reportee).uniq
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
    inc_vat(amount) * 0.3
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

  private

  def defaults
    self.fixed_fee ||= 0.35
    self.hourly_rate ||= 500
  end

  def generate_checklists
    self.checklists.create(title: 'Arbetsorder')
  end
end
