class PersonMigration < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :type, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :password, :string
      t.column :password_confirmation, :string
      t.column :email, :string
      t.column :phone, :integer
      t.timestamps
    end 
  end

  def self.down
    drop_table :people
  end
end
