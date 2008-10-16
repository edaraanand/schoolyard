class TeamMigration < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :team_name, :string
      t.column :classroom_id, :integer
      t.column :year, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
