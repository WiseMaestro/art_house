class Artist < ActiveRecord::Base
  
  has_many :works
  
  validates_presence_of :name, :bio, :sizex, :sizey
end
