class PeopleFieldMigration < ActiveRecord::Migration
  def self.up
      remove_column :people, :phone
      add_column :people, :phone, :string
  end

  def self.down
      add_column :people, :phone, :integer
      remove_column :people, :phone
  end
end
