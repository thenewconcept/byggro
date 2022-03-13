class User < ApplicationRecord
  has_secure_password

  has_one :worker, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }


  def display_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.present?
      first_name
    else
      email
    end
  end

  def is_worker?
    worker.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end
end