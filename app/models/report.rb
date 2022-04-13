class Report < ApplicationRecord
  attr_accessor :time_in_hours, :time_formated

  before_validation :set_fee

  belongs_to :reportee, polymorphic: true
  belongs_to :reportable, polymorphic: true

  validates_associated :reportee, :reportable
  validates :time_in_minutes, numericality: true, allow_blank: false, presence: true
  validates :date, presence: true

  scope :by_reportees, -> (type) { where(reportee_type: type) } 
  scope :by_checklist, -> (checklist) { where(reportable: checklist) }
  scope :by_project,   -> (project) { where(reportable: project).or(self.where(reportable_type: 'Checklist', reportable_id: project.checklists.pluck(:id))) }

  def total
    time_in_hours * fee
  end

  def project
    return reportable if reportable.is_a?(Project)
    return reportable.project if reportable.is_a?(Checklist)
  end

  def time_in_hours
    time_in_minutes&./60.0&.round(2)
  end

  def time_in_hours=(value)
    write_attribute(:time_in_minutes, value.to_f * 60.0)
  end

  private

  def set_fee
    unless self.fee = reportee.fees.at_date(self.date)&.amount
      self.errors.add(:fee, 'cannot be nil', message: 'cannot find valid fee for this date')
    end
  end
end