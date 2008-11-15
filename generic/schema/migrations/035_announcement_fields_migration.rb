class AnnouncementFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :announcements, :approved, :boolean
    add_column :announcements, :approve_announcement, :boolean
  end

  def self.down
    remove_column :announcements, :approved
    remove_column :announcements, :approve_announcement
  end
end
