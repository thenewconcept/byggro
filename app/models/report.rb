class Report < ApplicationRecord
  validates :time_in_minutes, numericality: true, allow_blank: false, presence: true
  validates :date, presence: true

  validates_associated :worker
  validates_associated :checklist

  belongs_to :worker
  belongs_to :checklist
end