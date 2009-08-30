class CalendarMigration < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.column :class_name, :string
      t.column :title, :string
      t.column :description, :text
      t.column :location, :string
      t.column :day_event, :boolean
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :start_time, :time
      t.column :end_time, :time
      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
