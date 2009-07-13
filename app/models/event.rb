require 'bit_string'
class Event < ActiveRecord::Base
  #extensions
  acts_as_bit_string :field => :properties
  @@properties = ['live_music','serves_alcohol', 'beginner_frienldly', 'advance_only']
  
  #associations
  belongs_to :venue
  belongs_to :user
  #validations
  validates_format_of :url, :with => /http:\/\//, :allow_blank => true
  validates_presence_of :name, :description, :date_start, :date_end
  validates_numericality_of :minimum_age, :allow_nil => true, :only_integer => true, :greater_than => -1, :less_than => 100
  
  attr_protected :venue_id, :user_id
  
  def self.event_types
    return [
      ['Team Practice', 'team_practice'],
      ['Social', 'social'],
      ['Dance Lesson', 'dance_lesson'],
      ['Congress', 'congress'],
      ['Festival', 'festival']
    ]
  end
end
