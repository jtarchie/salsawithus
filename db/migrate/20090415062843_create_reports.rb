class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.belongs_to :user
      t.integer :item_id
      t.string :item_type
      t.integer :value, :default => 0
      t.timestamps
    end
    add_index :reports, [:item_id, :item_type]
  end

  def self.down
    drop_table :reports
  end
end
