class AddIsSellerColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_seller, :boolean, default: false
  end
end
