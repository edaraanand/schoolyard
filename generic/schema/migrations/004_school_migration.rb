class SchoolMigration < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.column :school_name, :string
      t.column :phone, :string
      t.column :email, :string
      t.timestamps
    end 
  end

  def self.down
    drop_table :schools
  end
end
