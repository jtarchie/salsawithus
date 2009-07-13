# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def create_user
    @user = User.find_or_create_by_facebook_id(facebook_session.user.facebook_id) unless facebook_session.blank?
  end
  
  def require_user
    unless @user
      render :text => 'A user is required to be logged in to perform this action.', :status => :unauthorized
      return false
    end
  end
end
