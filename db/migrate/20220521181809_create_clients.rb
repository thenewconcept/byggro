class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nid
      t.string :company_name
      t.string :street_adress
      t.integer :zipcode
      t.string :city

      t.timestamps
    end
    add_index :clients, :nid
  end
end
