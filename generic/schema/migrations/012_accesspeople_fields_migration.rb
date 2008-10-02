class AccesspeopleFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :access_peoples, :subject_id, :integer
    add_column :access_peoples, :home_page, :boolean
  end

  def self.down
    remove_column :access_peoples, :subject_id
    remove_column :access_peoples, :home_page
  end
end
