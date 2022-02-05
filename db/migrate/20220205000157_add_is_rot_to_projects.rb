class AddIsRotToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :is_rot, :boolean, default: true, null: false
  end
end
