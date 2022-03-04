class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :worker, null: false, foreign_key: true
      t.references :checklist, null: false, foreign_key: true
      t.date :date
      t.integer :time_in_minutes
      t.string :note

      t.timestamps
    end
  end
end
