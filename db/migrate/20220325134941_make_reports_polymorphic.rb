class MakeReportsPolymorphic < ActiveRecord::Migration[7.0]
  def change
    add_reference :reports, :reportable, polymorphic: true, index: true
    add_reference :reports, :reportee, polymorphic: true, index: true
    remove_column :reports, :worker_id, :integer
    remove_column :reports, :checklist_id, :integer
  end
end
