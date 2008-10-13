class TeamFieldMigration < ActiveRecord::Migration
  def self.up
     add_column :class_peoples, :team_id, :integer
  end

  def self.down
     remove_column :class_peoples, :team_id
  end
end
