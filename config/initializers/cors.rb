# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000',
            /https?:\/\/(.*).cloudfront.net/
    # regular expressions can be used here

    resource '/assets/*',
             headers: :any,
             methods: [:get]
    resource '/webpack/*',
             headers: :any,
             methods: [:get]
  end
end
