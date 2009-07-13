class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      #associations an event can be tied to multiple things
      t.belongs_to :venue #always has to be somewhere
      t.belongs_to :user #the user that contributed the information
      t.belongs_to :modified_user
      #general information of event
      t.string :name, :url
      t.text :description
      #keeps track of different properties
      t.string :properties
      #the minimum age for the event
      t.integer :minimum_age, :default => 0
      #when date range does it happen in
      t.datetime :date_start, :date_end
      #keep track of what type of event -- practice, social, congress, etc...
      t.string :event_type
      t.boolean :display, :default => false
      t.timestamps
    end
    
    add_index :events, [:venue_id, :date_start, :date_end]
  end

  def self.down
    drop_table :events
  end
end
