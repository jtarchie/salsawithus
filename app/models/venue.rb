class Venue < ActiveRecord::Base
  # associations
  belongs_to :user
  belongs_to :modified_user, :class_name => 'User'
  has_many :events
  has_many :flagged, :source => :reports, :conditions => {:item_type => 'Venue', :value=>Report::FLAG}, :foreign_key => 'item_id', :class_name => "Report"
  has_many :favorited, :source => :reports, :conditions => {:item_type => 'Venue', :value=>Report::STAR}, :foreign_key => 'item_id', :class_name => "Report"
  # extensions
  acts_as_mappable
  # callbacks
  # validations
  validates_format_of :url, :with => /http:\/\//, :allow_blank => true, :message=>"must start with http://"
  validates_presence_of :name, :address 
  
  attr_protected :user_id, :display, :modified_user_id
  
  def before_validation
    #clean up the URL
    self.url = ("http://" + self.url) if !self.url.blank? && self.url !~ /^http:\/\//
  end
  
  def validate
    #looking for duplicate entries based on lat and lng
    return unless self.has_coords?
    #apparently MySQL doesn't like direct comparison for floats
    venue = Venue.find(:first, :conditions=>["ABS(lat - ?) <= 0.0001 AND ABS(lng - ?) <= 0.0001", self.lat, self.lng])
    self.errors.add(:address, " has already been added.") if !venue.blank? && venue.id != self.id
  end
  
  def geocode_address!
    geo = GeoKit::Geocoders::MultiGeocoder.geocode(address)
    unless geo.success
      self.errors.add(:address, "could not locate address")
    else
      self.lat, self.lng, self.address = geo.lat, geo.lng, geo.full_address
    end
  end
  
  def has_coords?
    return !(self.lat.zero? && self.lng.zero?)
  end
  
  def self.venue_types
    return [
      ['Club', 'club'],
      ['Studio', 'dance_studio'],
      ['Bar', 'bar'],
      ['Hotel', 'hotel'],
      ['Convention Center', 'convention_center']
    ]
  end
  
  def flag!(user)
    self.flagged.find_or_create_by_user_id(user.id) if user
  end
  
  def favorite!(user)
    self.favorited.find_or_create_by_user_id(user.id) if user
  end
end
