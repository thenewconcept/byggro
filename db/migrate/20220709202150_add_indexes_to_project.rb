class AddIndexesToProject < ActiveRecord::Migration[7.0]
  def up
    add_index :projects, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :projects, :adress, using: :gin, opclass: :gin_trgm_ops
  end

  def down
    remove_index :projects, :title
    remove_index :projects, :adress
  end
end
