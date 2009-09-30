class TimeCaptureFieldMigration < ActiveRecord::Migration
  def self.up
    add_column :people_tasks, :task_date, :date
  end

  def self.down
    remove_column :people_tasks, :task_date
  end
end
