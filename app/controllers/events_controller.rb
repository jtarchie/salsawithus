class EventsController < ApplicationController
  before_filter :set_facebook_session, :except=>[:index, :show]
  before_filter :create_user
  before_filter :require_user, :only=>[:create, :update, :edit]
  
  caches_page :show, :new
  cache_sweeper :event_sweeper, :only=>[:update]
  layout "application", :only=>[:show, :edit]
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
    @event.venue_id = params[:venue_id]
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def create
    @event = Event.new(params[:event])
    @event.user_id = @user.id
    @event.save
  end
  
  def update
    @event = Event.find(params[:id])
    @event.attributes = params[:event]
    @event.modified_user_id = @user.id
    @event.save
  end
  
end
