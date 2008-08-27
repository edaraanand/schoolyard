class AnnouncementMigration < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :expiration, :date      
      t.timestamps
    end 
  end

  def self.down
    drop_table :announcements
  end
end
