class CategoryMigration < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :report_id, :integer
      t.column :category_name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
