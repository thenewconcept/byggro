class AddNewChecklistColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :checklists, :payout, :integer, default: 0
    add_column :checklists, :hourly_rate, :integer, default: 0
  end
end
