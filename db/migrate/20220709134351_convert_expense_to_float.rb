class ConvertExpenseToFloat < ActiveRecord::Migration[7.0]
  def change
    change_column :expenses, :amount, :float, default: 0.0
  end
end
