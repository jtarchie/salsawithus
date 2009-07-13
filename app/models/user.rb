class User < ActiveRecord::Base
  has_many :venues
  has_many :events
  has_many :flagged_venues, :source => :reports, :conditions => {:item_type => 'Venue', :value=>Report::FLAG}, :class_name => "Report"
  has_many :favorited_venues, :source => :reports, :conditions => {:item_type => 'Venue', :value=>Report::STAR}, :class_name => "Report"
  validates_presence_of :facebook_id
  validates_numericality_of :facebook_id
end
