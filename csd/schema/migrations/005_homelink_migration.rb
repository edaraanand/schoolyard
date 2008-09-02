class HomelinkMigration < ActiveRecord::Migration
  def self.up
    create_table :homelinks do |t|
      t.column :title, :string
      t.column :link, :string
      t.timestamps
    end
 
  end

  def self.down
    drop_table :homelinks
  end
end
