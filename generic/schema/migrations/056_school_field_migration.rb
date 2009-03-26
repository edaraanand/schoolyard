class SchoolFieldMigration < ActiveRecord::Migration
  def self.up
    add_column :schools, :address, :text
  end

  def self.down
    remove_column :schools, :address
  end
end
