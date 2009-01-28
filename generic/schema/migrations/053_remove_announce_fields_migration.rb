class RemoveAnnounceFieldsMigration < ActiveRecord::Migration
  def self.up
     remove_column :announcements, :file_file_name
     remove_column :announcements, :file_content_type
     remove_column :announcements, :file_file_size
     add_column :announcements, :school_id, :integer
     add_column :home_works, :school_id, :integer
     add_column :protectors, :school_id, :integer
     add_column :registrations, :school_id, :integer
     add_column :spot_lights, :school_id, :integer
  end

  def self.down
     add_column :announcements, :file_file_name, :string 
     add_column :announcements, :file_content_type, :string 
     add_column :announcements, :file_file_size, :integer
     remove_column :announcements, :school_id
     remove_column :home_works, :school_id
     remove_column :protectors, :school_id
     remove_column :registrations, :school_id
     remove_column :spot_lights, :school_id
  end
end
