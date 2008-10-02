class ClassroomFieldMigration < ActiveRecord::Migration
  def self.up
      remove_column :classrooms, :type_id
      add_column :classrooms, :class_type, :string
  end

  def self.down
      add_column :classrooms, :type_id, :integer
      remove_column :classrooms, :class_type	
  end
end
