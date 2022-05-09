class RemoveIsRotColumnFromProjects < ActiveRecord::Migration[7.0]
  def up
    Project.where(is_rot: true).each do |project|
      project.checklists.update(is_rot: true)
    end
    remove_column :projects, :is_rot, :boolean
  end

  def down
    add_column :projects, :is_rot, :boolean, default: false
    checklist.where(is_rot: true).each do |checklist|
      checklist.project.update(is_rot: true)
    end
  end
end
