class WelcomemessageMigration < ActiveRecord::Migration
  def self.up
    create_table :welcomemessages do |t|
      t.column :message, :text
      t.timestamps
    end
 
  end

  def self.down
    drop_table :welcomemessages
  end
end
