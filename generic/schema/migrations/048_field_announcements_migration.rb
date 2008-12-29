class FieldAnnouncementsMigration < ActiveRecord::Migration
  def self.up
    remove_column :announcements, :comments
    add_column :announcements, :approved_by, :integer
    add_column :announcements, :rejected_by, :integer
    add_column :announcements, :approve_comments, :text
    add_column :announcements, :reject_comments, :text
  end

  def self.down
    add_column :announcements, :comments, :text
    remove_column :announcements, :approved_by
    remove_column :announcements, :rejected_by
    remove_column :announcements, :approve_comments
    remove_column :announcements, :reject_comments
  end
end
