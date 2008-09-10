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
Merb::Router.prepare do |r|
  # RESTful routes
  # r.resources :posts

   r.add_slice(:MerbAuth, 'auth')
   
   r.resources :users, :member => {:disable => :get}
   r.resources :schools
   r.resources :calendars
   r.resources :announcements, :member => {:preview => :any} 
   r.resources :homelinks,  :member => {:preview => :any}
   r.match("/externallinks/edit").to(:controller => 'homelinks', :action => 'edit').name(:externallinks_edit)
   r.match("/externallinks/update").to(:controller => 'homelinks', :action => 'update').name(:externallinks_update)

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  r.default_routes
  
  # Change this for your home page to be available at /
  r.match('/').to(:controller => 'schools', :action => 'index')
end
