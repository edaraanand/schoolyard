class LoggerMachineMigration < ActiveRecord::Migration
  def self.up
    create_table :logger_machines do |t|
      t.column :twilio_call_id, :string
      t.column :person_id, :integer
      t.column :school_id, :integer
      t.column :announcement_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :logger_machines
  end
end
