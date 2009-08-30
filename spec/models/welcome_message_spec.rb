require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe WelcomeMessage do

  
   before(:each) do
     @welcome_message = WelcomeMessage.new({:content => 'We are in our 3rd week – the half way point – of our collection for the Yolo County Food Bank and you guys are doing a great job!'})
   end

   it "should be invalid without a Content" do
      @welcome_message.should be_valid
      @welcome_message.content = ''
      @welcome_message.should_not be_valid
      @welcome_message.errors.on(:content).should eql("can't be blank")
   end


end