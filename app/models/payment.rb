class Payment < ApplicationRecord
  validates :amount, presence: true
  belongs_to :project

  def initialize(attributes = nil)
    super
    self.payed_on ||= Date.today
  end
end
