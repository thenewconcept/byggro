class AddRotToChecklists < ActiveRecord::Migration[7.0]
  def change
    add_column :checklists, :is_rot, :boolean, default: false
  end
end
