class AddCompletedAtToProjects < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :completed_at, :date

    Project.where(status: 'completed').each do |project|
      completed_date = Report.by_project(project).order(date: :asc).last.date
      project.update_attribute(:completed_at, completed_date)
    end
  end

  def down
    remove_column :projects, :completed_at, :date
  end
end
