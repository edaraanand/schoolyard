require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/ranks" do
  before(:each) do
    @response = request("/ranks")
  end
end