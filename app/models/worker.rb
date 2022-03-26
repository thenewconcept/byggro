class Worker < ApplicationRecord
  has_many :reports, as: :reportee, dependent: :destroy
  validates :user, presence: true, uniqueness: true
  belongs_to :user

  delegate :email, :password, :first_name, :last_name, :full_name, :display_name, to: :user
end