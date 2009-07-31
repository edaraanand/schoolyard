require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/files" do
  before(:each) do
    @response = request("/files")
  end
end