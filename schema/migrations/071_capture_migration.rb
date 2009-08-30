class CaptureMigration < ActiveRecord::Migration
  def self.up
    create_table :captures do |t|
      t.column :title, :string
      t.column :expiration, :date
      t.column :school_staff, :boolean
      t.column :school_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :captures
  end
end
