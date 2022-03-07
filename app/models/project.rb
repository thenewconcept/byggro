class Project < ApplicationRecord
  include Bonusable

  enum bonus: [ :none, :hourly, :fixed ], _prefix: true
  enum status: { upcoming: 'upcoming', started: 'started', completed: 'completed' }, _prefix: true

  validates :material_amount, :misc_amount, numericality: true

  after_create :generate_checklists
  has_rich_text :description
  has_many :checklists, dependent: :destroy
  has_many :reports, through: :checklists
  has_many :todos, through: :checklists

  def hours_reported
    reports.sum(:time_in_minutes) / 60.0
  end

  def amount
    checklists.sum(&:amount)
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

  def generate_checklists
    self.checklists.create(title: 'Arbetsorder')
    self.checklists.create(title: 'ÄTA')
  end
end
