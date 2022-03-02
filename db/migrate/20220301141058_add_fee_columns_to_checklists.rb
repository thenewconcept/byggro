class AddFeeColumnsToChecklists < ActiveRecord::Migration[7.0]
  def change
    add_column :checklists, :amount, :integer, default: 0, null: false
  end
end
