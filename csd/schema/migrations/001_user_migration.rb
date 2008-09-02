class UserMigration < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :phone, :string
      t.column :password, :string
      t.column :content_access, :boolean
      t.column :manage_access, :boolean
      t.column :settings_access, :boolean
      t.column :event_access, :boolean
      t.column :message_access, :boolean
      t.column :links_access, :boolean
      t.column :announcement_access, :boolean
      t.column :files_access, :boolean
      t.timestamps
    end 
  end

  def self.down
    drop_table :users
  end
end
