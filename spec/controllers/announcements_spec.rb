require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Announcements, "index action" do
  before(:each) do
    dispatch_to(Announcements, :index)
  end
end