class AddStatusToProjects < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE project_status AS ENUM ('upcoming', 'started', 'completed');
    SQL

    add_column :projects, :status, :project_status, default: 'upcoming', null: false
    add_index :projects, :status
  end

  def down
    remove_index :projects, :status
    remove_column :projects, :status
    execute <<-SQL
      DROP TYPE project_status;
    SQL
  end
end
