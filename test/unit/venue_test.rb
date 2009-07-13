require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  fixtures :venues
  
  should_validate_presence_of :name, :address
  should_not_allow_mass_assignment_of :user_id, :display, :modified_user_id
  
  should_belong_to :user
  should_belong_to :modified_user
  should_have_many :events
  should_have_many :flagged
  should_have_many :favorited
end
