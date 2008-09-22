class Csd
  
  @@common_config = {
    :auth_mailman      => 'no-reply-csd@gmail.com',
    :mailman_password  => 'password',
    :bc_user => "basecamp user", 
    :bc_password => "basecamp password"
  }
  
  @@development_config = {
    :app_domain        => 'http://localhost:4000'
  }
  
  @@test_config = {
    :app_domain        => 'http://localhost:4000'
  }
  
  @@rake_config = {
    :app_domain        => 'http://localhost:4000'
  }
  
  @@production_config = {
    :app_domain        => 'http://csd.insightmethods.com'
  }
  
  def self.config(of)
    if defined?(Merb) && Merb.respond_to?(:env)
      class_eval("@@common_config.merge(@@#{Merb.env}_config)")[of.to_sym]
    else
      class_eval("@@common_config.merge(@@production_config)")[of.to_sym]
    end
  end
  
end