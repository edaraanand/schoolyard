require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe ExternalLinks, "index action" do
  before(:each) do
    dispatch_to(ExternalLinks, :index)
  end
end