class StudentAddressMigration < ActiveRecord::Migration
  def self.up
     add_column :people, :address1, :string
     add_column :people, :address2, :string
     add_column :people, :city, :string
     add_column :people, :state, :string
     add_column :people, :zip_code, :string
     add_column :people, :fax, :string
  end

  def self.down
     remove_column :people, :address1
     remove_column :people, :address2
     remove_column :people, :city
     remove_column :people, :state
     remove_column :people, :zip_code
     remove_column :people, :fax
  end
end
