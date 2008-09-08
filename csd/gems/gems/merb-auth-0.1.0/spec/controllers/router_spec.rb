require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

prefix = 'merb-auth'

describe "Router.add_slice(:MerbAuth)" do
  include Merb::Test::Rspec::RouteMatchers
  
  before(:all) do
    Merb::Router.prepare { |r| r.add_slice(:MerbAuth) } if standalone?
  end
  
  it "should have named routes for :login, :logout and :signup" do
    [:login, :logout, :signup].each do |name|
      url(name).should == "/#{prefix}/#{name}"
    end
  end

  it "should route /#{prefix}/login to Session#new" do
    request_to("/#{prefix}/login", :get).should route_to(MerbAuth::Users, :login)
  end

  it "should route /#{prefix}/login via post to Session#create" do
    request_to("/#{prefix}/login", :post).should route_to(MerbAuth::Users, :login)
  end

  it "should route /#{prefix}/logout via delete to Session#destroy" do
    request_to("/#{prefix}/logout", :delete).should route_to(MerbAuth::Users, :logout)
  end
end