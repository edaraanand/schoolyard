class AlertPeopleMigration < ActiveRecord::Migration
  def self.up
    create_table :alert_peoples do |t|
      t.column :alert_id, :integer
      t.column :person_id, :integer
      t.column :all, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :alert_peoples
  end
end
