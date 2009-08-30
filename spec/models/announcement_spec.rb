require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Announcement do

  before(:each) do
     @announcement = Announcement.new({:title => 'WASC VISIT', :content => 'We are in our 3rd week – the half way point – of our collection for the Yolo County Food Bank and you guys are doing a great job!'})
  end

   it "should be invalid without a Title" do
     @announcement.should be_valid
     @announcement.title = ''
     @announcement.should_not be_valid
     @announcement.errors.on(:title).should eql("can't be blank")
   end
   
   it "should be invalid without a Content" do
     @announcement.should be_valid
     @announcement.content = ''
     @announcement.should_not be_valid
     @announcement.errors.on(:content).should eql("can't be blank")
   end

end