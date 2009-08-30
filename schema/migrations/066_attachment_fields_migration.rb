class AttachmentFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :attachments, :school_id, :integer
  end

  def self.down
    remove_column :attachments, :school_id
  end
end
