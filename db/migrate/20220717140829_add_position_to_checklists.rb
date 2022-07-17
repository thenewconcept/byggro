class AddPositionToChecklists < ActiveRecord::Migration[7.0]
  def change
    add_column :checklists, :position, :integer
    Project.all.each do |project|
      project.checklists.order(:updated_at).each.with_index(1) do |list, index|
        list.update_column :position, index
      end
    end
  end
end
