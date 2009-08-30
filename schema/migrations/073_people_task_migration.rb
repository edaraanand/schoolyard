class PeopleTaskMigration < ActiveRecord::Migration
  def self.up
    create_table :people_tasks do |t|
      t.column :person_id, :integer
      t.column :task_id, :integer
      t.column :hours, :string
      t.column :comments, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :people_tasks
  end
end
