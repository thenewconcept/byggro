class AddDraftEnumTypeToProjects < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def up
    execute <<-SQL
      ALTER TYPE project_status ADD VALUE IF NOT EXISTS  'draft' BEFORE 'upcoming';
    SQL
    execute <<-SQL
      ALTER TABLE projects ALTER status SET DEFAULT 'draft';
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE projects ALTER status SET DEFAULT 'upcoming';
    SQL
  end
end
