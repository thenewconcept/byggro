class AddClientToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :client, foreign_key: true
  end
end
