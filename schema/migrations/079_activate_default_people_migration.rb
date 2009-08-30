class ActivateDefaultPeopleMigration < ActiveRecord::Migration
  def self.up
    change_column :people, :activate, :boolean, :default => true
    Person.find(:all).each do |p|
      p.activate = true
      p.save!
    end
  end

  def self.down
  end
end
