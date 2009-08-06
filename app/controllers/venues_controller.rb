class VenuesController < ApplicationController
  before_filter :set_facebook_session, :except=>[:index, :show]
  before_filter :create_user
  before_filter :require_user, :only=>[:create, :update, :flag, :favorite, :edit]
  
  #caches_page :show, :new
  #cache_sweeper :venue_sweeper, :only=>[:update]
  layout "application", :only=>[:show, :edit]
  
  def show
    @venue = Venue.find(params[:id])
  end
  
  def new
    @venue = Venue.new
  end
  
  def edit
    @venue = Venue.find(params[:id])
  end
  
  def create
    @venue = Venue.new(params[:venue])
    @venue.display = @venue.has_coords?
    @venue.user_id = @user.id
    @venue.save
    
    @user_action = VenuePublisher.create_publish_add(
      :user => facebook_session.user,
      :venue => @venue,
      :data => {
        :venue_name => @venue.name,
        :venue_url => url_for(:controller=>:map, :action=>:index, :id => @venue.id, :only_path=>false),
        :venue_map_url => url_for(:controller=>:map, :action=>:index, :address=>@venue.address, :only_path=>false),
        :images => [
          {
            :src => "http://maps.google.com/staticmap?center=#{@venue.lat},#{@venue.lng}&markers=#{@venue.lat},#{@venue.lng},smallred&zoom=13&size=75x75&key=#{Geokit::Geocoders::google}",
            :href => url_for(:controller=>:map, :action=>:index, :id => @venue.id, :only_path=>false)
          }
        ]
      }
    ) if @venue.display
  end
  
  def update
    @venue = Venue.find(params[:id])
    @venue.attributes = params[:venue]
    @venue.display = @venue.has_coords?
    @venue.modified_user_id = @user.id
    @venue.save
    
    @user_action = VenuePublisher.create_publish_edit(
      :user => facebook_session.user,
      :venue => @venue,
      :data => {
        :venue_name => @venue.name,
        :venue_url => url_for(:controller=>:map, :action=>:index, :id => @venue.id, :only_path=>false),
        :venue_map_url => url_for(:controller=>:map, :action=>:index, :address=>@venue.address, :only_path=>false),
        :images => [
          {
            :src => "http://maps.google.com/staticmap?center=#{@venue.lat},#{@venue.lng}&markers=#{@venue.lat},#{@venue.lng},smallred&zoom=13&size=75x75&key=#{Geokit::Geocoders::google}",
            :href => url_for(:controller=>:map, :action=>:index, :id => @venue.id, :only_path=>false)
          }
        ]
      }
    ) if @venue.display
    @user_notification = VenuePublisher.create_edit_notification(
      :from => facebook_session.user,
      :to => Facebooker::User.new(@venue.user.facebook_id),
      :venue => @venue,
      :venue_url => url_for(:controller=>:map, :action=>:index, :id => @venue.id, :only_path=>false)
    ) if @venue.display
  end
  
  def flag
    return unless @user
    @venue = Venue.find(params[:id])
    @venue.flag!(@user)
  end
  
  def favorite
    return unless @user
    @venue = Venue.find(params[:id])
    @venue.favorite!(@user)
  end
end
