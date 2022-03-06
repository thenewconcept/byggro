class Report < ApplicationRecord
  attr_accessor :time_in_hours, :time_formated

  validates :time_in_minutes, numericality: true, allow_blank: false, presence: true
  validates :date, presence: true

  validates_associated :worker
  validates_associated :checklist

  belongs_to :worker
  belongs_to :checklist

  delegate :project, to: :checklist

  def time_in_hours
    time_in_minutes&./60.0&.round(2)
  end

  def time_in_hours=(value)
    write_attribute(:time_in_minutes, value.to_f * 60.0)
  end
end