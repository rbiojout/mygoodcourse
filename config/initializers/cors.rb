# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do



  allow do
    origins %w[
                http://localhost:3000,
                http://127.0.0.1:3000,
                https://mygoodcourse.herokuapp.com,
                https://mygoodcourse-staging.herokuapp.com,
                https://www.mygoodcourse.com,
                https://djydktkci79tz.cloudfront.net,
                https://d1b6d82jm5evkl.cloudfront.net,
                http://djydktkci79tz.cloudfront.net,
                http://d1b6d82jm5evkl.cloudfront.net
            ]
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
