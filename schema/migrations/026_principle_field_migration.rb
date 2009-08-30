class PrincipleFieldMigration < ActiveRecord::Migration
  def self.up
     add_column :announcements, :label, :string
  end

  def self.down
     remove_column :announcements, :label
  end
end
