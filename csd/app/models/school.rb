class School < ActiveRecord::Base
  
  #has_attachment    :storage => :file_system, 
                  #  :content_type => :image,
                  #  :max_size => 1.megabytes,
                  #  :thumbnails => { :thumb => '64x64', :tiny => '32x32'},
                  #  #:path_prefix => 'public/school',
                  #  :processor => 'Rmagick'
end