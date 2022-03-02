class RemoveWorkAmountColumnFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :work_amount
  end
end
