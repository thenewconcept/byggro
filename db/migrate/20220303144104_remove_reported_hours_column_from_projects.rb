class RemoveReportedHoursColumnFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :reported_hours, :integer, default: 0, null: false
  end
end
