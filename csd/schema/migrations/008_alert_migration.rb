class AlertMigration < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.column :announcement_alert, :boolean
      t.column :event_alert, :boolean
      t.column :message_alert, :boolean
      t.column :file_alert, :boolean
      t.column :user_id, :integer
      t.timestamps
    end
 
  end

  def self.down
    drop_table :alerts
  end
end
