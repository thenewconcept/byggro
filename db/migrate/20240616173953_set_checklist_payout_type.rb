class SetChecklistPayoutType < ActiveRecord::Migration[7.1]
  def up
    Checklist.all.each do |checklist|
      payout = checklist.project.bonus_fixed? ? 'fixed' : 'hourly'
      checklist.update!(payout:)
    end
  end
end
