class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, :polymorphic => true

  validates_presence_of :value
  validates_numericality_of :value
  
  #options for the types of reporting
  FLAG = 1
  STAR = 2
end
