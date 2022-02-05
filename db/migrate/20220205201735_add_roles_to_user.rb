class AddRolesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_manager, :boolean, default: false
    add_column :users, :is_admin, :boolean, default: false
  end
end
