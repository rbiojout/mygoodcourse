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

    resource '*', :headers => :any, :methods => :any
  end

end
