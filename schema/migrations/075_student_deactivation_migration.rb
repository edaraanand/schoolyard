class StudentDeactivationMigration < ActiveRecord::Migration
  def self.up
    add_column :people, :activate, :boolean
  end

  def self.down
    remove_column :people, :activate
  end
end
