class Twitter < ActiveRecord::Base
  
   #belongs_to :school
 
   include HTTParty
   base_uri 'twitter.com'

    def initialize(user, pass)
        self.class.basic_auth user, pass
    end

    def post(text)
        self.class.post('/statuses/update.json', :query => {:status => text})
    end 
  
end
