class AddPayedOnColumnToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :payed_on, :date, default: nil
    rename_column :projects, :due_at, :due_on
    rename_column :projects, :starts_at, :starts_on
    rename_column :projects, :completed_at, :completed_on
  end
end
