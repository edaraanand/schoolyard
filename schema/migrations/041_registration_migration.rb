class RegistrationMigration < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.column :parent_id, :integer
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :birth_date, :date
      t.column :current_class, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
