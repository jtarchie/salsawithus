class VenueSweeper < ActionController::Caching::Sweeper
  observe Venue
  
  def after_save(venue)
    expire_page(:controller=>:venues, :action=>:show, :id=>venue.id)
    expire_page(:controller=>"api/venues", :action=>:show, :id=>venue.id)
  end
end
