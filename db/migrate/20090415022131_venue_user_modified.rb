class VenueUserModified < ActiveRecord::Migration
  def self.up
    add_column :venues, :modified_user_id, :integer
  end

  def self.down
    remove_column :venues, :modified_user_id
  end
end
