class AddFixedFeeToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :fixed_fee, :float, default: nil
    Project.update_all(fixed_fee: 0.35)
  end
end
