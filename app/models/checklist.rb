class Checklist < ApplicationRecord
  include Budgetable
  validates :title, presence: true
  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 
  belongs_to :project

  delegate :hourly_rate, to: :project
end
