require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/notifications" do
  before(:each) do
    @response = request("/notifications")
  end
end