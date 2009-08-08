class SpotLightFieldMigration < ActiveRecord::Migration
  def self.up
    remove_column :spot_lights, :avatar_file_name
    remove_column :spot_lights, :avatar_content_type
    remove_column :spot_lights, :avatar_file_size
    add_column :spot_lights, :title, :string
    add_column :spot_lights, :last_name, :string
  end

  def self.down
    add_column :spot_lights, :avatar_file_name,    :string
    add_column :spot_lights, :avatar_content_type, :string
    add_column :spot_lights, :avatar_file_size,    :integer
    remove_column :spot_lights, :title
    remove_column :spot_lights, :last_name
  end
end
