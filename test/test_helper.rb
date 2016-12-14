ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests
    # in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # CarrierWave::Mount::Mounter.class_eval { def store!; end }
    CarrierWave.root = Rails.root.join('test/fixtures/files')
    def after_teardown
      super
      CarrierWave.clean_cached_files!(0)
      # clean all the files manipulated by CarrierWave in uploads folder
      FileUtils.rm_rf(Rails.root.join('test/fixtures/files/uploads'))
    end
  end
end

module CarrierWave
  module Mount
    class Mounter
      # def store!
      # Not storing uploads in the tests
      # end
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    # Setup all fixtures in test/fixtures/*.yml for all tests
    # in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # we need to have a special treatment for files in the Integration Tests
    # we keep them
    CarrierWave.root = Rails.root.join('test/fixtures/files')
    def after_teardown
      super
      CarrierWave.clean_cached_files!(0)
    end

    # Reset sessions and driver between tests
    # Use super wherever this method is redefined in your individual test classes
    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end
