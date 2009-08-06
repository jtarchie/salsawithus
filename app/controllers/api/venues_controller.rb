class Api::VenuesController < ApplicationController
  before_filter :set_facebook_session, :except=>[:index, :show]
  
  #caches_page :show
  #cache_sweeper :venue_sweeper, :only=>[:update]
  
  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all :conditions=>{:display=>true}, :origin=>[params[:lat].to_f, params[:lng].to_f], :within=>30

    respond_to do |format|
      #format.html # index.html.erb
      format.json  { render :json => @venues.to_json(:except=>[:display, :user_id, :modified_user_id]), :callback=>params[:callback] }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      #format.html # show.html.erb
      format.json { render :json => @venue.to_json(:except=>[:display, :user_id, :modified_user_id]), :callback=>params[:callback] }
    end
  end

#TODO: add proper authentication for these features
=begin
  # GET /venues/new
  # GET /venues/new.json
  def new
    @venue = Venue.new
    
    respond_to do |format|
      #format.html # new.html.erb
      format.json  { render :json => @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])
    
    respond_to do |format|
      if @venue.save
        flash[:notice] = 'Venue was successfully created.'
        #format.html { redirect_to(@venue) }
        format.json  { render :json => @venue, :status => :created, :location => @venue }
      else
        #format.html { render :action => "new" }
        format.json  { render :json => @venue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        flash[:notice] = 'Venue was successfully updated.'
        #format.html { redirect_to(@venue) }
        format.json  { head :ok }
      else
        #format.html { render :action => "edit" }
        format.json  { render :json => @venue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      #format.html { redirect_to(venues_url) }
      format.json  { head :ok }
    end
  end
=end
end
