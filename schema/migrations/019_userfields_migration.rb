class UserfieldsMigration < ActiveRecord::Migration
  def self.up
     add_column :users, :crypted_password, :string
     add_column :users, :salt, :string
     add_column :users, :active, :boolean
     add_column :users, :identity_url, :string
     add_column :people, :person_bio, :text
     add_column :people, :address, :text
     add_column :users, :username, :string
     remove_column :people, :password
     remove_column :people, :password_confirmation
  end

  def self.down
     remove_column :users, :crypted_password
     remove_column :users, :salt
     remove_column :users, :active
     remove_column :users, :identity_url
     remove_column :people, :person_bio
     remove_column :people, :address
     remove_column :users, :username
     add_column :people, :password, :string
     add_column :people, :password_confirmation, :string
  end
end
