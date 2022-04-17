class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, foreign_key: true

      t.date  :spent_on, null: false
      t.string :category, null: false
      t.string :description
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
