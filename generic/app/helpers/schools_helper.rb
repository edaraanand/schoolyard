module Merb
    module SchoolsHelper
      
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