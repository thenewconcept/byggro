class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :project, null: false, foreign_key: true
      t.date :payed_on
      t.integer :amount
      t.string :notes
    end
  end
end
