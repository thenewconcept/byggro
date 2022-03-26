class Report < ApplicationRecord
  attr_accessor :time_in_hours, :time_formated

  belongs_to :reportee, polymorphic: true
  belongs_to :reportable, polymorphic: true

  validates_associated :reportee, :reportable
  validates :time_in_minutes, numericality: true, allow_blank: false, presence: true
  validates :date, presence: true

  def self.by_project(project)
    self
      .where(reportable: project)
      .or(self.where(reportable_type: 'Checklist', reportable_id: project.checklists.pluck(:id)))
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
end