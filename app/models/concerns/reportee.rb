module Reportee
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates :user, presence: true, uniqueness: true

    before_save :log_fee_changes
    has_many :reports, as: :reportee, dependent: :destroy
    has_many :fees, as: :reportee, dependent: :destroy
  end

  delegate :email, :password, :roles, :primary_role, :first_name, :last_name, :full_name, :display_name, to: :user

  private

  def log_fee_changes
    self.fees.new(amount: fee) if fee_changed? or new_record?
  end
end