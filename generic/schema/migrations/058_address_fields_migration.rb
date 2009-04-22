class AddressFieldsMigration < ActiveRecord::Migration
  def self.up
    remove_column :schools, :address
    add_column :schools, :address1, :string
    add_column :schools, :address2, :string
    add_column :schools, :city, :string
    add_column :schools, :state, :string
    add_column :schools, :zip_code, :string
    add_column :schools, :fax, :string
  end

  def self.down
    add_column :schools, :address, :text
    remove_column :schools, :address1
    remove_column :schools, :address2
    remove_column :schools, :city
    remove_column :schools, :state
    remove_column :schools, :zip_code
    remove_column :schools, :fax
  end
end
