class AccessMigration < ActiveRecord::Migration
  def self.up
    create_table :accesses do |t|
      t.column :name, :string
      t.column :full_name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :accesses
  end
end
