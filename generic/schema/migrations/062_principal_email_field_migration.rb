class PrincipalEmailFieldMigration < ActiveRecord::Migration
  
    def self.up
      add_column :attachments, :principal_email, :boolean
    end
   
    def self.down
      remove_column :attachments, :principal_email
    end
  
end
