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
  
   
  end
end
