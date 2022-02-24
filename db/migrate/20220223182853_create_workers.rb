class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :salary
      t.string :title

      t.timestamps
    end
  end
end
