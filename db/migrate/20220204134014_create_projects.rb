class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :adress
      t.text :description

      t.integer :work_amount, default: 0
      t.integer :material_amount, default: 0
      t.integer :misc_amount, default: 0

      t.timestamps
    end
  end
end
