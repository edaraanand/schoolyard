class ExternalLinkMigration < ActiveRecord::Migration
  def self.up
    create_table :external_links do |t|
      t.column :label, :string
      t.column :title, :string
      t.column :url, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :external_links
  end
end
