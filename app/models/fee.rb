class Fee < ApplicationRecord
  belongs_to :reportee, polymorphic: true
  validates_associated :reportee

  def self.at_date(date)
    where('created_at::date <= ?', date).order(created_at: :desc).first
  end
end