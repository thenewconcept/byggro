class Client < ApplicationRecord
  belongs_to :user
  validates_associated :user
  accepts_nested_attributes_for :user

  has_many :projects
  delegate :first_name, :last_name, :email, :phone, to: :user

  def display_name
    company_name.presence || user.display_name
  end
end
