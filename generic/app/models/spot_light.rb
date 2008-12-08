class SpotLight < ActiveRecord::Base
  
   attr_accessor :tempfile
   #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    
    def url
      puts "Naidu".inspect
      #(Merb.root, "/uploads/#{ self.id }")
      #(Merb.root, "/uploads/#{self.id}/#{self.avatar_file_name}")
    end

  
    def self.from(fileparams)
        spot_light = SpotLight.new do |s|
          s.avatar_content_type = fileparams[:content_type]
          s.avatar_file_name = fileparams[:filename]
          s.avatar_file_size = fileparams[:size]
         end 
       spot_light.tempfile = fileparams[:tempfile]
       puts "Eshwar".inspect
       return spot_light
    end
   
    def spot_light_dir_path
        File.join(Merb.root, "/uploads/#{ self.id }")
    end
 
    def spot_light_file_path
        File.join(spot_light_dir_path, "/#{ self.avatar_file_name }")
    end

    def after_create
        move_file
        #create_thumbnails
    end

    def move_file
       FileUtils.makedirs(spot_light_dir_path)
      # FileUtils.cp(tempfile.path, spot_light_file_path)  
    end

    def create_thumbnails
       image = MiniMagick::Image.read(spot_light_file_path)
       image.resize "200X140"
       thumbnail = File.open("#{Merb.root}/tmp/thumbnails/thumb_"+rand(10000).to_s+".tmp","wb+")
       image.write thumbnail.path
       #when I add the following 4 lines, the error occurs
      # img.change_geometry!(164x164) { |cols, rows, imgg|
       #imgg.thumbnail!(cols, rows)
      #}
      # image.write(File.join(spot_light_dir_path, "/thumb_#{self.filename}"))
    end


end
