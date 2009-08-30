class AlertMigration < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.column :name, :string
      t.column :full_name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
