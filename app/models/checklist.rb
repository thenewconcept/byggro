class Checklist < ApplicationRecord
  include Bonusable

  belongs_to :project
  validates :title, presence: true

  has_many :reports, as: :reportable, dependent: :destroy
  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 

  delegate :hourly_rate, to: :project
end
