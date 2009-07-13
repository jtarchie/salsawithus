require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  context "GET /events/1" do
    setup do
      get :show, :id => 1
    end
    
  end
end
