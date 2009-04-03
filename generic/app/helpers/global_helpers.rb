module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    
    def link_to_function(content, options)
      unless options.is_a?(Hash)
        options = {:action => options}
      end
      tag(:a, content, :href => "javascript:;", :onclick => "#{options[:action]};return false;", :title => options[:title])
    end
    
     def error_messages_for(object)
      #return if !object.respond_to?(:errors) || object.errors.empty?
      "<ul class='error_messages'>#{object.errors.full_messages.map{|msg| "<li>#{msg}</li>" }.join}</ul>"
     end
   
     def link_to_if(right, name, url = "")
        @acc = Access.find_by_name(right)
        have_access = false
        session.user.access_peoples.each do |f|
          have_access = f.all || (@acc.id == f.access_id)
          break if have_access
        end
        if have_access
           link_to(name, url)
        end
     end
     
     def link_to_right(right, name, url = "")
        @acc = Access.find_by_name(right)
        have_access = false
        session.user.access_peoples.each do |f|
          have_access = f.all || (@acc.id == f.access_id)
          break if have_access
        end
        if have_access
           link_to(name, url)
          # else
          # '<span class=cancel>'+name+' </span>'
        end
     end

     def truncate(text, *args)
         options = args.extract_options!
         unless args.empty?
           ActiveSupport::Deprecation.warn('truncate takes an option hash instead of separate ' +
             'length and omission arguments', caller)
 
           options[:length] = args[0] || 30
           options[:omission] = args[1] || "..."
         end
         options.reverse_merge!(:length => 30, :omission => "...")
 
         if text
           l = options[:length] - options[:omission].mb_chars.length
           chars = text.mb_chars
           (chars.length > options[:length] ? chars[0...l] + options[:omission] : text).to_s
         end
       end
       

     def snippet(thought, wordcount)
         thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? " …" : "") 
     end
     
     def san_content(content)
         content.gsub("\r\n","<br/>")
    end
     def email(address)
          '<a href="mailto:'+address+'">'+address+'</a>'
     end
     
     
         def number_to_phone(number, options = {})
           number       = number.to_s.strip unless number.nil?
            options      = options.symbolize_keys
            area_code    = options[:area_code] || nil
            delimiter    = options[:delimiter] || "-"
            extension    = options[:extension].to_s.strip || nil
            country_code = options[:country_code] || nil

            begin
              str = ""
              str << "+#{country_code}#{delimiter}" unless country_code.blank?
              str << if area_code
                number.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4}$)/,"(\\1) \\2#{delimiter}\\3")
              else
                number.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4})$/,"\\1#{delimiter}\\2#{delimiter}\\3")
              end
            str << " x #{extension}" unless extension.blank?
              str
            rescue
              number
            end
          end

             def format_phone_number(number)
       return "(#{number[0..2]})#{number[3..5]}-{number[6..-1]}"
     end
    


  end
end
