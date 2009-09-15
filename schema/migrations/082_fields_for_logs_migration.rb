class FieldsForLogsMigration < ActiveRecord::Migration
  def self.up
    add_column :logger_machines, :sms_code, :string
  end

  def self.down
    remove_column :logger_machines, :sms_code
  end
end
