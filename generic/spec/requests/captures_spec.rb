require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/captures" do
  before(:each) do
    @response = request("/captures")
  end
end