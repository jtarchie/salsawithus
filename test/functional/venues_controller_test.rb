require 'test_helper'

class VenuesControllerTest < ActionController::TestCase
  context "GET /venues/1" do
    setup do
      get :show, :id => 1
    end
    
    should_assign_to :venue
    should_render_template :show
    should_respond_with :success
    should_not_set_the_flash
    
    should "Check for valid venue model" do
      assert_equal 1, assigns(:venue).id
    end
  end
  
  context "/venues/new" do
    setup do
      get :new
    end
    
    should_assign_to :venue
    should_render_template :new
    should_respond_with :success
    should_not_set_the_flash
    
    should "Check for valid venue model" do
      assert_equal true, assigns(:venue).new_record?
      assert_equal false, assigns(:venue).save
    end
  end
  
  context "/venues/1/edit without logged in user" do
    setup do
      get :edit, :id => 1
    end
    
    should_respond_with :unauthorized
  end
  
  context "/venues/1/edit with logged in user" do
    setup do 
      setup_facebook_session
      get :edit, :id => 1
    end
    
    should_assign_to :venue
    should_render_template :edit
    should_respond_with :success
    should_not_set_the_flash

    should "Check for valid venue model" do
      assert_equal 1, assigns(:venue).id
    end
  end
  
  def setup_facebook_session
    
  end
end
