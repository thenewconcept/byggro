class CreateFees < ActiveRecord::Migration[7.0]
  def up
    add_column :contractors, :updated_at, :datetime, null: true
    add_column :contractors, :created_at, :datetime, null: true

    Contractor.update_all(created_at: Time.now, updated_at: Time.now)

    change_column_null :contractors, :updated_at, false
    change_column_null :contractors, :created_at, false

    create_table :fees do |t|
      t.references :reportee, polymorphic: true, null: false
      t.integer :amount

      t.timestamps
    end

    [Contractor, Intern, Employee].each do |klass|
      klass.all.each do |reportee| 
        Fee.create(reportee: reportee, amount: reportee.fee, created_at: reportee.created_at)
      end
    end

    Report.find_each(&:save)
  end

  def down
    drop_table :fees
    remove_column :contractors, :updated_at
    remove_column :contractors, :created_at
  end
end