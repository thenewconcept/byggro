class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone, :string
    add_column :employees, :pid, :string
    add_column :employees, :bank, :string
    add_column :employees, :account, :string
    add_column :contractors, :cid, :string
  end
end
