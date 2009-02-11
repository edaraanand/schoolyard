module File
  
   def uploaded_data() nil; end
     
   def uploaded_data=(file_data)
        if file_data.respond_to?(:content_type)
          return nil if file_data.size == 0
          self.content_type = file_data.content_type
          self.filename     = file_data.original_filename if respond_to?(:filename)
        else
          return nil if file_data.blank? || file_data['size'] == 0
          self.content_type = file_data['content_type']
          self.filename =  file_data['filename']
          file_data = file_data['tempfile']
        end
        if file_data.is_a?(StringIO)
           file_data.rewind
           self.temp_data = file_data.read
        else
           self.temp_path = file_data
        end
   end
   
   def temp_path
        p = temp_paths.first
        p.respond_to?(:path) ? p.path : p.to_s
   end

      # Gets an array of the currently used temp paths.  Defaults to a copy of #full_filename.
   def temp_paths
        @temp_paths ||= (new_record? || !respond_to?(:full_filename) || !File.exist?(full_filename) ?
          [] : [copy_to_temp_file(full_filename)])
   end
   
     def temp_path=(value)
         temp_paths.unshift value
         temp_path
      end

      # Gets the data from the latest temp file.  This will read the file into memory.
      def temp_data
        save_attachment? ? File.read(temp_path) : nil
      end

      
       def temp_data=(data)
        self.temp_path = write_to_temp_file data unless data.nil?
      end

      # Copies the given file to a randomly named Tempfile.
      def copy_to_temp_file(file)
        self.class.copy_to_temp_file file, random_tempfile_filename
      end

      # Writes the given file to a randomly named Tempfile.
      def write_to_temp_file(data)
        self.class.write_to_temp_file data, random_tempfile_filename
      end
 
      def create_temp_file() end
     
        
end
