class ClassFieldMigration < ActiveRecord::Migration
  def self.up
     remove_column :classrooms, :teacher_name
     add_column :classrooms, :person_id, :integer
  end

  def self.down
     add_column :classrooms, :teacher_name, :string
     remove_column :classrooms, :person_id
  end
end
