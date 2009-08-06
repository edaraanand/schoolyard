class TaskMigration < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :name, :string
      t.column :capture_id, :integer
      t.column :school_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
