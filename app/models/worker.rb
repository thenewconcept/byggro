class Worker < ApplicationRecord
  has_many :reports, as: :reportee, dependent: :destroy
  validates :user, presence: true, uniqueness: true
  belongs_to :user
end