class ClassPeopleMigration < ActiveRecord::Migration
  def self.up
    create_table :class_peoples do |t|
      t.column :classroom_id, :integer
      t.column :person_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :class_peoples
  end
end
