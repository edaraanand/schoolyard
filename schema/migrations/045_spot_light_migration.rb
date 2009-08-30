class SpotLightMigration < ActiveRecord::Migration
  def self.up
    create_table :spot_lights do |t|
      t.column :class_name, :string
      t.column :student_name, :string
      t.column :content, :text
      t.column :avatar_file_name,    :string
      t.column :avatar_content_type, :string
      t.column :avatar_file_size,    :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :spot_lights
  end
end
