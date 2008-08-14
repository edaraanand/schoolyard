class ClassroomMigration < ActiveRecord::Migration
  def self.up
    create_table :classrooms do |t|
      t.column :class_name, :string
      t.column :teacher_name, :string
      t.column :type_id, :integer
      t.timestamps
    end 
  end

  def self.down
    drop_table :classrooms
  end
end
