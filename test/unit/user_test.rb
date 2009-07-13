require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  should_validate_presence_of :facebook_id
  should_validate_numericality_of :facebook_id
  
  should_have_many :venues
  should_have_many :flagged_venues
  should_have_many :favorited_venues
end
