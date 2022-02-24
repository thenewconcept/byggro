class AddReportedHoursToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :reported_hours, :float, default: 0.0, null: false
  end
end
