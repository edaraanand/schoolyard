class AncestorMigration < ActiveRecord::Migration
  def self.up
    create_table :ancestors do |t|
      t.column :student_id, :integer
      t.column :protector_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :ancestors
  end
end
