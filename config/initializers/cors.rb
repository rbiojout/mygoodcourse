# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do



  allow do
    origins '*'

    # regular expressions can be used here

    resource '*', :headers => :any, :methods => :any
  end

end
