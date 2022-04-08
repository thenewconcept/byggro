class AddFeeToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :fee, :integer
  end
end
