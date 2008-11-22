class PeoplesFieldsMigration < ActiveRecord::Migration
  def self.up
    add_column :people, :birth_date, :date
    add_column :people, :approved, :boolean
    add_column :people, :password_reset_key, :string
  end

  def self.down
    remove_column :people, :birth_date
    remove_column :people, :approved
    remove_column :people, :password_reset_key
  end
end
