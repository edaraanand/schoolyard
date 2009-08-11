
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")
gem "pdf-writer"

# ==== Dependencies

require 'ftools'
require 'config/dependencies.rb'
require  Merb.root / 'lib' / 'smtp_tls'
require  Merb.root / 'lib' / 'constantz'
require  Merb.root / 'lib' / 'attachable'
require "pdf/writer"
require "pdf/simpletable"
require 'rubygems'
require 'httparty'
require 'clickatell'
require 'spreadsheet'
require 'spreadsheet/excel'

use_orm :activerecord
use_test :rspec
#use_template_engine :erb
#use_template_engine :haml

Merb::BootLoader.after_app_loads do

  gem 'will_paginate', '~> 3.0.0'
  require 'will_paginate'
  Clickatell::API.debug_mode = true
 
  Merb::Mailer.config = {
    :host   => 'smtp.gmail.com',
    :port   => '587',
    :user   => 'noreply@schoolyardapp.com',
    :pass   => '75F633',
    :auth   => :plain
  }

  WillPaginate::ViewHelpers::LinkRenderer.class_eval do
    protected

    def url(page)
      params = @template.request.params.except(:action, :controller).merge('page' => page)
      @template.url(:this, params.merge(@options[:params] || {}))
    end
  end

  Merb::AbstractController.send(:include, WillPaginate::ViewHelpers::Base)
  

end

# ==== Set up your basic configuration

Merb::Config.use do |c|

  # Sets up a custom session id key, if you want to piggyback sessions of other applications
  # with the cookie session store. If not specified, defaults to '_session_id'.
  c[:session_id_key] = '_scapp_session_id'

  c[:session_secret_key]  = 'cb559b9d1afded91073666b345eebe8e8f41f213'
  c[:session_store] = 'cookie'
  c[:disabled_components] = [:signals]
end


