class ClasstypeMigration < ActiveRecord::Migration
  def self.up
    create_table :classtypes do |t|
      t.column :class_type, :string
      t.timestamps
    end 
  end

  def self.down
    drop_table :classtypes
  end
end
