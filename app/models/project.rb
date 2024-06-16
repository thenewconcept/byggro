class Project < ApplicationRecord
  include Reportable
  include Taxes

  BONUS_FIXED = ENV['BONUS_FIXED']&.to_f || 0.35
  BONUS_SALES = ENV['BONUS_SALES']&.to_f || 0.02
  ROT_PERCENT = ENV['ROT_PERCENT']&.to_f || 0.3

  enum status: { draft: 'draft', upcoming: 'upcoming', started: 'started', completed: 'completed' }, _prefix: true

  scope :by_contractor,  -> (contractor) { joins(:contractors).where(contractors: {id: contractor}) }
  scope :status_ongoing, -> { where(status: ['draft', 'upcoming', 'started']) }
  scope :up_for_bonus, -> { where(status: 'completed').where('completed_on >= ?', 2.months.ago) }

  validates :material_amount, :misc_amount, numericality: true
  validates :completed_on, presence: true, if: :status_completed?

  before_validation :check_completion, if: -> { status_changed?(to: 'completed') }

  has_rich_text :description

  has_and_belongs_to_many :contractors
  has_many :payments, dependent: :destroy
  has_many :expenses, dependent: :destroy

  has_many :checklists, -> { order(position: :asc) }, dependent: :destroy
  has_many :reports, through: :checklists
  has_many :todos, through: :checklists

  has_many :notes

  has_many :assignments
  has_many :users, through: :assignments

  belongs_to :client
  belongs_to :seller, class_name: 'User', optional: true

  def is_rot?
    checklists.any?(&:is_rot?)
  end

  def progress
    return 0 if todos.blank?
    (todos.completed.count.to_f / todos.count.to_f).round(2)
  end

  def primary_date
    starts_on.present? ?  starts_on : created_at.to_date
  end

  def hours_estimated
    checklists&.sum(&:hours_target)&.round(0)
  end

  def rot_amount
    checklists.where(is_rot: true).sum(&:amount)
  end

  def rot
    add_taxes(rot_amount, :vat) * ROT_PERCENT
  end

  def client_costs
    client_payed + rot
  end

  def client_payed
    add_taxes(total, :vat) - rot - add_taxes(material_amount, :vat)
  end

  def total
    Calculator::Base.new(self).total_revenue
  end

  private

  def check_completion
    unless self.checklists.all?(&:completed?)
      errors.add(:base, 'Alla checklistor måste vara klara för avslut')
    else
      self.completed_on = self.reports.first&.date || Time.zone.now.to_date unless completed_on.present?
    end
  end
end
