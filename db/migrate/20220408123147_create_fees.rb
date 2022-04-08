class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.references :reportee, polymorphic: true, null: false
      t.integer :amount

      t.timestamps
    end
  end
end
