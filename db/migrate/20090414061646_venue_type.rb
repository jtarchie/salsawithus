class VenueType < ActiveRecord::Migration
  def self.up
    add_column :venues, :venue_type, :string
  end

  def self.down
    remove_column :venues, :venue_type
  end
end
