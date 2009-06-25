class PrincipalEmailFieldMigration < ActiveRecord::Migration
  
    def self.up
      add_column :people, :principal_email, :boolean
      add_column :people, :principal_name, :boolean
    end
   
    def self.down
      remove_column :people, :principal_email
      remove_column :people, :principal_name
    end
  
end
