class RemoveenabledMigration < ActiveRecord::Migration
  def self.up
      remove_column :users, :enabled
  end

  def self.down
      add_column :users, :enabled, :boolean
  end
end
