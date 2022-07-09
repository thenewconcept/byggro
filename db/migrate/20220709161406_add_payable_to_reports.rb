class AddPayableToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :payable, :boolean, default: true, null: false
  end
end
