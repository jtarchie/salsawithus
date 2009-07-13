class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_page(:controller=>:events, :action=>:show, :id=>event.id)
    expire_page(:controller=>"api/events", :action=>:show, :id=>event.id)
  end
end
