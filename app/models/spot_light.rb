class SpotLight < ActiveRecord::Base

  attr_accessor :image

  belongs_to :school

  validates_presence_of :student_name, :last_name, :content

  def name
    (student_name and last_name) ? student_name + ' ' + last_name : ''
  end


end
