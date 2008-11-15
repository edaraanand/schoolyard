class AnnounceFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :announcements, :comments, :text
  end

  def self.down
    remove_column :announcements, :comments
  end
end
