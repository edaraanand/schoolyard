class AlertSettingsMigration < ActiveRecord::Migration
  def self.up
    add_column :alerts, :type, :string
    add_column :alert_peoples, :classroom_id, :integer
  end

  def self.down
    remove_column :alerts, :type
    remove_column :alert_peoples, :classroom_id
  end
end
