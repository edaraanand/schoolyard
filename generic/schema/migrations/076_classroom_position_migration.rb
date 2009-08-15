class ClassroomPositionMigration < ActiveRecord::Migration
  def self.up
    add_column :classrooms, :position, :integer, :default => 0
  end

  def self.down
    remove_column :classrooms, :position
  end
end
