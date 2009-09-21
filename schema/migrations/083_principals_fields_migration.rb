class PrincipalsFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :schools, :principal_id, :integer
  end

  def self.down
    remove_column :schools, :principal_id
  end
end
