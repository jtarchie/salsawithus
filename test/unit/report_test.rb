require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :reports
  should_validate_presence_of :value
  should_validate_numericality_of :value
  
  should_belong_to :user
  should_belong_to :item
end
