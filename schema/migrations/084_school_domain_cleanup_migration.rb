class SchoolDomainCleanupMigration < ActiveRecord::Migration
  def self.up
    remove_column :schools, :domain
  end

  def self.down
  end
end
