class ClassroomDeactivationMigration < ActiveRecord::Migration
  def self.up
    add_column :classrooms, :activate, :boolean
  end

  def self.down
    remove_column :classrooms, :activate
  end
end
