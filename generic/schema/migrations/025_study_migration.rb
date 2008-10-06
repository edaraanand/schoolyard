class StudyMigration < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.column :student_id, :integer
      t.column :classroom_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :studies
  end
end
