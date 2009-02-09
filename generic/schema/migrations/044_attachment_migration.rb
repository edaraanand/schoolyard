class AttachmentMigration < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :filename, :string
      t.column :content_type, :string
      t.column :size, :integer
      t.column :height, :integer
      t.column :width, :integer
      t.column :parent_id, :integer
      t.column :position, :integer
      t.column :attachable_id, :integer
      t.column :thumbnail, :string
      t.column :attachable_type, :string
      t.timestamps
    end
    add_index :attachments, :parent_id
    add_index :attachments, [:attachable_id, :attachable_type]
  end

  def self.down
    drop_table :attachments
  end
end

    
