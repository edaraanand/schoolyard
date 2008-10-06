class GuardianMigration < ActiveRecord::Migration
  def self.up
    create_table :guardians do |t|
      t.column :student_id, :integer
      t.column :parent_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :guardians
  end
end
