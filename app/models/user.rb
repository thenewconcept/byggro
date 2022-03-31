class User < ApplicationRecord
  has_secure_password
  
  before_create { self.email = email.downcase }

  has_one :contractor, dependent: :destroy
  has_one :worker, dependent: :destroy

  has_many :assignments
  has_many :projects, through: :assignments

  accepts_nested_attributes_for :worker
  accepts_nested_attributes_for :contractor

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def roles
    roles = []
    roles << 'Anställd' if worker.present?
    roles << 'Underentrepenör' if contractor.present?
    roles << 'Arbetsledare' if is_manager?
    roles << 'Admin' if is_admin?
    return roles.join(', ')
  end

  def profile
    return worker if is_worker?
    return contractor if is_contractor?
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence
  end

  def display_name
    (full_name || email)
  end

  def is_contractor?
    contractor.present?
  end

  def is_worker?
    worker.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end
end