class AccessPeopleFieldsMigration < ActiveRecord::Migration
  def self.up
      add_column :access_peoples, :class_id, :integer
      add_column :access_peoples, :all, :boolean
  end

  def self.down
      remove_column :access_peoples, :class_id
      remove_column :access_peoples, :all
  end
end
