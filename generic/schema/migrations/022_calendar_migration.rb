class CalendarMigration < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.column :class_name, :string
      t.column :title, :string
      t.column :description, :text
      t.column :location, :string
      t.column :day_event, :boolean
      t.column :start_date, :datetime
      t.column :end_date, :datetime	    
      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
