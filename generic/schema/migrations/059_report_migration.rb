class ReportMigration < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.column :subject_name, :string
      t.column :person_id, :integer
      t.column :school_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
