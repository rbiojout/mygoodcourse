# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do



  allow do
    origins '*'
    # regular expressions can be used here

    resource '/public/*',
             # Allow any request headers to be sent in the asset request
             # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#Access-Control-Allow-Headers
             :headers => :any,
             # All asset fetches should be via GET
             # Support OPTIONS for pre-flight requests
             # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#Preflighted_requests
             :methods => [:get, :options]
    resource '/assets/*', :headers => :any, :methods => [:get, :options]
    resource '/webpack/*', :headers => :any, :methods => [:get, :options]
  end

end
