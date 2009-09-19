class PrincipalsFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :schools, :principal_id, :integer
  end

  def self.down
    add_column :schools, :principal_id
  end
end
