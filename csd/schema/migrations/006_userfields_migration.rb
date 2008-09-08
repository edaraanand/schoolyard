class UserfieldsMigration < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table :users do |t|
      t.string :name, :limit => 40, :null => false
      t.string :username, :limit => 40, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40, :null => false
      t.string :remember_token
      t.date   :remember_token_expires_at
      t.string :phone
      t.boolean :content_access
      t.boolean :manage_access
      t.boolean :settings_access
      t.boolean :event_access
      t.boolean :message_access
      t.boolean :links_access
      t.boolean :announcement_access
      t.boolean :files_access
      t.timestamps
    end
  end

  def self.down
    drop_table :users
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
end
