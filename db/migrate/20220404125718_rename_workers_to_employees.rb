class RenameWorkersToEmployees < ActiveRecord::Migration[7.0]
  def up
    rename_table :workers, :employees
    Report.where(reportee_type: 'Worker').update_all(reportee_type: 'Employee')
  end

  def down
    rename_table :employees, :workers
    Report.where(reportee_type: 'Employee').update_all(reportee_type: 'Worker')
  end
end
