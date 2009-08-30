class RankMigration < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.column :student_id, :integer
      t.column :assignment_id, :integer
      t.column :name, :string
      t.column :from,  :float
      t.column :to,  :float
      t.column :school_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :ranks
  end
end
