class GradeMigration < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.column :student_id, :integer
      t.column :assignment_id, :integer
      t.column :score, :integer
      t.column :percentage, :float
      t.column :grade, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
