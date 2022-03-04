class Checklist < ApplicationRecord
  include Budgetable
  belongs_to :project
  validates :title, presence: true

  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 
  has_many :reports, dependent: :destroy

  delegate :hourly_rate, to: :project
end
