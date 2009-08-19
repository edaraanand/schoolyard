class ChangeScoreTypeMigration < ActiveRecord::Migration
  def self.up
    change_column :grades, :score, :float
  end

  def self.down
    change_column :grades, :score, :integer
  end
end
