class WelcomeMessageMigration < ActiveRecord::Migration
  def self.up
    create_table :welcome_messages do |t|
      t.column :access_name, :string
      t.column :person_id, :integer
      t.column :message, :string
      t.column :content, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :welcome_messages
  end
end
