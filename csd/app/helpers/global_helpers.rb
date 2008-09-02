module Merb
  module GlobalHelpers
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end
    
    def link_to_function(content, options)
      unless options.is_a?(Hash)
        options = {:action => options}
      end
      tag(:a, content, :href => "javascript:;", :onclick => "#{options[:action]};return false;", :title => options[:title])
    end
  end
end
