class ExternalFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :external_links, :classroom_id, :integer
  end

  def self.down
    remove_column :external_links, :classroom_id
  end
end
