class VoiceAlertsMigration < ActiveRecord::Migration
  def self.up
    add_column :people, :voice_alert, :string
    add_column :people, :sms_alert, :string
  end

  def self.down
    remove_column :people, :voice_alert
    remove_column :people, :sms_alert
  end
end
