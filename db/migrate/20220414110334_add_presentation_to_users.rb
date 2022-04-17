class AddPresentationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :presentation, :string
  end
end
