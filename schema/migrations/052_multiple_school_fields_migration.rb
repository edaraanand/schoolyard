class MultipleSchoolFieldsMigration < ActiveRecord::Migration
   def self.up
    add_column :people, :school_id, :integer
    add_column :calendars, :school_id, :integer
    add_column :external_links, :school_id, :integer
    add_column :forms, :school_id, :integer
    add_column :welcome_messages, :school_id, :integer
    add_column :classrooms, :school_id, :integer
    add_column :teams, :school_id, :integer
    add_column :schools, :domain, :string
    add_column :schools, :folder, :string
    add_column :schools, :subdomain, :string
  end

  def self.down
    remove_column :people, :school_id
    remove_column :calendars, :school_id
    remove_column :external_links, :school_id
    remove_column :forms, :school_id
    remove_column :welcome_messages, :school_id
    remove_column :classrooms, :school_id
    remove_column :teams, :school_id
    remove_column :schools, :domain
    remove_column :schools, :folder
    remove_column :schools, :subdomain
  end
end
