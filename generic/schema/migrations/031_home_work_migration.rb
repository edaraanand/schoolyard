class HomeWorkMigration < ActiveRecord::Migration
  def self.up
    create_table :home_works do |t|
      t.column :classroom_id, :integer
      t.column :title, :string
      t.column :content, :text
      t.column :due_date, :date
      t.timestamps
    end
  end

  def self.down
    drop_table :home_works
  end
end
