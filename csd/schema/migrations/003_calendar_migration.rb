class CalendarMigration < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :location, :string
      t.column :start_time, :datetime
      t.column :end_time, :datetime
      t.timestamps
    end 
  end

  def self.down
    drop_table :calendars
  end
end
