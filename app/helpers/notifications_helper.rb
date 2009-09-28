module Merb
  module NotificationsHelper

    def post_urgent_announcement_later(id)
      # make sure there is an actual announcement before hitting apis for delivery
      @announcement = @current_school.announcements.find_by_id(id) rescue NotFound   


      # Run everything off the thread; each service needs to run on its own thread without
      # interfering with the others
      #
      # Plan to have this run for 10k unique phone numbers
      run_later do
        make_call(id)
      end

      run_later do
        post_sms(id)
      end

      run_later do
        post_twitter(id)
      end
      
      run_later do
        @announcement = @current_school.announcements.find_by_id(id) rescue NotFound   
        @announcement.mail(:urgent_announcement, :subject => "Urgent Announcement for " + @current_school.school_name)
      end

    end

    def make_call(id)
      @announcement = @current_school.announcements.find_by_id(id)
      @people = @current_school.people.find(:all)
      @people.each do |f|
         unless f.voice_alert.blank?
            begin  
              account = TwilioRest::Account.new( Schoolapp.config(:twilio_account_id), Schoolapp.config(:twilio_account_token))
              resp =  account.request("/#{Schoolapp.config(:twilio_api_version)}/Accounts/#{Schoolapp.config(:twilio_account_id)}/Calls.csv", 'POST',
                                            d = { 'Caller' => Schoolapp.config(:caller_id),
                                                  'Called' => "#{f.voice_alert}",
                                                  'Url' => "http://#{@current_school.subdomain}.#{Schoolapp.config(:app_domain)}" + "/reminder?id=#{@announcement.id}" })
              sID = resp.body.gsub("\n", ",").split(",")
              LoggerMachine.create({:person_id => f.id, :school_id => @current_school.id, :twilio_call_id => sID[15], :announcement_id => @announcement.id})                                     
              resp.error! unless resp.kind_of? Net::HTTPSuccess  
            rescue StandardError => bang
              return  
            end  
         end
      end
    end

    def post_sms(id)
      sms_numbers = []
      @announcement = @current_school.announcements.find_by_id(id)
      numbers = @current_school.people.find(:all).collect{ |x| x.sms_alert }.compact.delete_if{|x| x == ""}.collect{|x| "1" + x }
      api = Clickatell::API.authenticate(Schoolapp.config(:clickatell_api), Schoolapp.config(:clickatell_user), Schoolapp.config(:clickatell_password))
      unless numbers.empty?
        numbers.each do |f|
           msg_code = api.send_message("#{f}", "#{@announcement.content}")
           n = f.split(',').flatten
           i = n[0].split('')
           l = i.shift
           sms_numbers << "#{i.join()}"
           @person = @current_school.people.find_by_sms_alert("#{i.join()}")
           LoggerMachine.create({:person_id => @person.id, :school_id => @current_school.id, :announcement_id => @announcement.id, :sms_code => "#{msg_code}"})  
        end
      end
    end

    def post_twitter(id)
      @announcement = @current_school.announcements.find_by_id(params[:id]) rescue NotFound   
      twitter = Twitter.new(@current_school.username, @current_school.password)
      twitter.post(@announcement.content)
    end


  end
end # Merb