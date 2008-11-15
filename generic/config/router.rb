# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do 
  # RESTful routes
  
 #r.add_slice(:MerbAuth, 'auth')
  
  #match("/login").
   # to(:controller => 'sessions', :action => 'new').
    #name(:login)
  #match("/logout").
   # to(:controller => 'sessions', :action => 'destroy').
    #name(:logout)
    slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "") 
authenticate do
  resources :parents
  resources :approvals
  resources :schools
  resources :people
  resources :alerts
  resources :classrooms
  resources :homes
  resources :announcements
  resources :welcome_messages
  resources :calendars
  resources :students
  resources :teams
  resources :from_principals
  resources :home_works
  resources :external_links
  match("/externallinks/edit").to(:controller => 'external_links', :action => 'edit').name(:external_links_edit)
  match("/externallinks/update").to(:controller => 'external_links', :action => 'update').name(:external_links_update)
  match("/alerts_edit").to(:controller => 'alerts', :action => 'edit').name(:alert_edit)
  match("/alerts_update").to(:controller => 'alerts', :action => 'update').name(:alert_update)
  match("/staff_account").to(:controller => 'users', :action => 'staff_account').name(:staff_account)
  match("/staff_account_edit").to(:controller => 'users', :action => 'staff_account_edit').name(:staff_account_edit)
  match("/staff_account_update").to(:controller => 'users', :action => 'staff_account_update').name(:staff_account_update)
  match("/staff_password").to(:controller => 'users', :action => 'staff_password').name(:staff_password)
  match("/staff_password_update").to(:controller => 'users', :action => 'staff_password_update').name(:staff_password_update)
  match("/publish").to(:controller => 'approvals', :action => 'publish').name(:publish)
  match("/reject").to(:controller => 'approvals', :action => 'reject').name(:reject)
end
  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes
  
  # Change this for your home page to be available at /
  #authenticate do
  match('/').to(:controller => 'homes')
  #end
end