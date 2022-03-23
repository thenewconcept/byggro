class Contractor < ApplicationRecord
  validates :user, presence: true, uniqueness: true
  has_many :reports
  belongs_to :user
end