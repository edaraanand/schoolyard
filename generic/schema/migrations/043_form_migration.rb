class FormMigration < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.column :title, :string
      t.column :class_name, :string
      t.column :year, :string
      t.column :filename, :string
      t.column :content_type, :string
      t.column :size, :integer
      t.column :attachable_id, :integer
      t.column :attachable_type, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :forms
  end
end
