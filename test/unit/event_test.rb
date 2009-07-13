require 'test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :events
  
  should_belong_to :venue
  should_belong_to :user
  
  should_not_allow_mass_assignment_of :venue_id, :user_id
  should_not_allow_values_for :url, "www.yahoo.com", "www.google.com"
  should_allow_values_for :url, "http://www.yahoo.com", "http://www.google.com"
  should_validate_presence_of :name, :description, :date_start, :date_end
  should_validate_numericality_of :minimum_age
  
end
