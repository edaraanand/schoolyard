class ClassPeopleFieldMigration < ActiveRecord::Migration
  def self.up
      add_column :class_peoples, :role, :string
  end

  def self.down
      remove_column :class_peoples, :role
  end
end
