class HomeWorkFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :home_works, :person_id, :integer
    add_column :people, :title, :string
  end

  def self.down
    remove_column :home_works, :person_id
    remove_column :people, :title
  end
end
