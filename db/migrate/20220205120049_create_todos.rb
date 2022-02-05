class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.references :checklist, null: false, foreign_key: true
      t.boolean :completed, null: false, default: false
      t.string :description

      t.timestamps
    end
  end
end
