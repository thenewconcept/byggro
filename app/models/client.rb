class Client < ApplicationRecord
  belongs_to :user
  validates_associated :user
  accepts_nested_attributes_for :user

  has_many :projects
  delegate :first_name, :last_name, :email, :display_name, :phone, to: :user
end
