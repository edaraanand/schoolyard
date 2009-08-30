class ExternalLink < ActiveRecord::Base


  belongs_to :school
  belongs_to :classroom

  validates_presence_of :title, :url


end
