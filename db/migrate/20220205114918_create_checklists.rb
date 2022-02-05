class CreateChecklists < ActiveRecord::Migration[7.0]
  def change
    create_table :checklists do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
