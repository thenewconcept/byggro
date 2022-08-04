class ContractorsProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :contractors_projects, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :contractor, index: true
    end
  end
end
