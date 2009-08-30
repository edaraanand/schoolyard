require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/reports" do
  before(:each) do
    @response = request("/reports")
  end
end