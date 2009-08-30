class FormDescriptionFieldMigration < ActiveRecord::Migration
  def self.up
    add_column :forms, :description, :text
  end

  def self.down
    remove_column :forms, :description
  end
end
