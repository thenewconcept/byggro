class AddHourlyRateToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :hourly_rate, :float, default: 0.0, null: false
  end
end
