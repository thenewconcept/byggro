module Reportee
  extend ActiveSupport::Concern

  included do
    before_save :log_fee_changes
    has_many :reports, as: :reportee, dependent: :destroy
    has_many :fees, as: :reportee, dependent: :destroy
  end


  private

  def log_fee_changes
    self.fees.new(amount: fee) if fee_changed?
  end
end