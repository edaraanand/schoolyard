module Merb
  module GlobalHelpers 
     #before :login_required
 
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end
    
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

  end

end



 		    
