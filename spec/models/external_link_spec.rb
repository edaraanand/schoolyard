require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe ExternalLink do

 before(:each) do
   @external_link = ExternalLink.new({:title => 'Google', :url => 'www.google.com'})
  end

   it "should be invalid without a Title" do
      @external_link.should be_valid
      @external_link.title = ''
      @external_link.should_not be_valid
      @external_link.errors.on(:title).should eql("can't be blank")
   end
   
   it "should be invalid without a Url" do
      @external_link.should be_valid
      @external_link.url = ''
      @external_link.should_not be_valid
      @external_link.errors.on(:url).should eql("can't be blank")
   end

end