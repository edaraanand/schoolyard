class UserMigration < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :phone, :string
      t.column :password, :string
      t.column :contentId, :boolean
      t.column :manageId, :boolean
      t.column :settingsId, :boolean
      t.column :eventId, :boolean
      t.column :messageId, :boolean
      t.column :linksId, :boolean
      t.column :announcementId, :boolean
      t.column :filesId, :boolean
      t.timestamps
    end 
  end

  def self.down
    drop_table :users
  end
end
