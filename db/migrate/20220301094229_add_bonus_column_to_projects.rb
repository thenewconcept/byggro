class AddBonusColumnToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :bonus, :integer, default: 0
  end
end
