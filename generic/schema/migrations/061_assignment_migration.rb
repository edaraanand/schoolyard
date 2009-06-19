class AssignmentMigration < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.column :category_id, :integer
      t.column :name, :string
      t.column :date, :date
      t.column :max_point, :integer
      t.column :score, :integer
      t.column :school_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
