class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :adress
      t.string :description

      t.integer :work_amount
      t.integer :material_amount
      t.integer :misc_amount

      t.timestamps
    end
  end
end
