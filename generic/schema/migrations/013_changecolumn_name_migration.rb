class ChangecolumnNameMigration < ActiveRecord::Migration
  def self.up
     rename_column :access_peoples, :access_right_id, :access_id
  end

  def self.down
     rename_column :access_peoples, :access_right_id, :access_id
  end
end
