class TwitterFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :schools, :username, :string
    add_column :schools, :password, :string
  end

  def self.down
    remove_column :schools, :username
    remove_column :schools, :password
  end
end
