class AccessPeopleMigration < ActiveRecord::Migration
  def self.up
    create_table :access_peoples do |t|
      t.column :access_right_id, :integer
      t.column :person_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :access_peoples
  end
end
