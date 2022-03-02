module Budgetable
  extend ActiveSupport::Concern

  def estimated_hours
    amount / hourly_rate
  end
end