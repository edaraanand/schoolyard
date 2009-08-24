require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/directories" do
  before(:each) do
    @response = request("/directories")
  end
end