# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
# in order to test the integration with a headless browser
# we use Phantomjs and poltergeist
require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false,
                                         default_wait_time: 20,
                                         timeout: 60,
                                         js_errors: true,
                                         phantomjs_options: ['--load-images=yes'])
end

Capybara.javascript_driver = :poltergeist
# time out set in driver
Capybara.default_max_wait_time = 20

# make simple matchers for ActiveRecord
require 'shoulda/matchers'
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

require 'devise'

require 'support/factory_girl'

require 'support/database_cleaner'

require 'support/controller_macros'

RSpec.configure do |config|
  config.before(:each) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test/*"])
    FileUtils.cp_r(Dir["#{Rails.root}/spec/fixtures/files/uploads/*"], Dir["#{Rails.root}/public/uploads/test"])
  end
end


RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::ControllerHelpers, type: :helper
  config.extend ControllerMacros, type: :controller
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Warden::Test::Helpers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # the fixtures for the default files must be already installed
  # in the public folder
  # run the bundle exec rake clean_tests:clean_files if needed
  # it will reset the default file fixtures used by the factories
  # and associated to CarrierWave

  # we load all fixture first thing
  config.global_fixtures = :all

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # use of DatabaseClearner to do the job
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # we use the default pictures
  # that are located in the public part to be served
  # in /public/uploads/test
  # make sure the fixtures are present
  CarrierWave.root = Rails.root.join('public')

  if defined?(CarrierWave)
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/public/uploads/test/tmp"
        end

        def store_dir
          "#{Rails.root}/public/uploads/test/#{model.class.to_s.underscore}/#{mounted_as}"
        end
      end
    end
  end
end
