class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      #venue is always created by a user
      t.belongs_to :user
      #descriptive information about the venue
      t.string :name, :url, :address, :phone_number
      #the description of the venue -- expand for details?
      t.text :description
      #the latitude and longitude of the venue
      t.float :lat, :lng, :default => 0
      #has the venue been verified?
      t.boolean :display, :default => true
      t.timestamps
    end
    add_index :venues, :user_id
    add_index :venues, [:lat, :lng, :display]
  end

  def self.down
    drop_table :venues
  end
end
