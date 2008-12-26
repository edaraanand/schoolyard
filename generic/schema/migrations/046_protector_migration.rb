class ProtectorMigration < ActiveRecord::Migration
  def self.up
    create_table :protectors do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :protectors
  end
end
