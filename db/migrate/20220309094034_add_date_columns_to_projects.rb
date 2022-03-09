class AddDateColumnsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :starts_at, :date
    add_column :projects, :due_at, :date
  end
end
