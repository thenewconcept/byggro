class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [500, 500]
  end

  has_secure_password
  
  before_create :sanitize

  has_one :contractor, dependent: :destroy
  has_one :employee, dependent: :destroy
  has_one :intern, dependent: :destroy
  has_one :client, dependent: :destroy

  has_many :assignments
  has_many :projects, through: :assignments

  accepts_nested_attributes_for :employee
  accepts_nested_attributes_for :contractor
  accepts_nested_attributes_for :client

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  scope :active, -> { where(active: true) }
  scope :sellers, -> { where(is_seller: true) }
  scope :contractors, -> { where_exists(:contractor) }
  scope :employees, -> { where_not_exists(:contractor) }

  def roles
    roles = []
    roles << 'Kund' if client.present?
    roles << 'Anställd' if employee.present?
    roles << 'Praktikant' if intern.present?

    roles << 'Underentrepenör' if contractor.present?
    roles << 'Koordinator' if is_manager?

    roles << 'Admin' if is_admin?
    return roles.join(', ')
  end

  def primary_role
    roles.split(', ').first
  end

  def title
    profile&.title || ''
  end

  def profile
    return employee if is_employee?
    return intern if is_intern?
    return contractor if is_contractor?
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence
  end

  def display_name
    (full_name || email)
  end

  def complete?
    first_name.present? && last_name.present? && email.present?
  end

  def profile_complete?
    complete? && profile.complete?
  end

  def is_client?
    client.present?
  end

  def is_worker?
    profile.present?
  end

  def is_contractor?
    contractor.present?
  end

  def is_employed?
    employee.present? || intern.present?
  end

  def is_employee?
    employee.present?
  end

  def is_intern?
    intern.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end

  def generate_password
    self.password = SecureRandom.hex(8)
  end

  private

  def sanitize
    self.email = email.downcase
    self.password = '123456' if password.blank?
  end
end