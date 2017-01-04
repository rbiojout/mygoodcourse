source 'https://rubygems.org'

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.7'

# sanitizer for html in activerecords
gem 'loofah-activerecord'

gem 'rails-i18n'

# country informations and flags
gem 'countries'
# we put the files in vendor directly
# gem 'famfamfam_flags_rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19'
# add some search with PostGres
gem 'pg_search'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# gem 'haml'


# Use jquery as the JavaScript library
## gem 'jquery-rails', '~> 4.2'

# add some additional jquery
## gem 'jquery-ui-rails'

# to solve problems with tough on ios
## gem 'touchpunch-rails'

# to solve reloading of pages
gem 'jquery-turbolinks'

# handle file upload with javascript, in particular for progress bar
# gem 'jquery-fileupload-rails'

# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# add devise for the users
gem 'devise', '~> 4.2'

# add pagination helper for listing the data
gem 'will_paginate'
# add some order in the models for lists
gem 'acts_as_list'
# gem 'nested_form_fields'
# add a counter for the visits
gem 'impressionist', '1.5.1'

# we want slugs for URL instead of numbers
gem 'friendly_id' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

# better work for nested forms the ajax is explains in the project page
gem 'cocoon'

# state engine for the models
# see https://github.com/aasm/aasm
gem 'aasm'

gem 'bower-rails'

# add some CSS
# recommended to use Autoprefixer with Bootstrap to add browser vendor prefixes automatically.
gem 'autoprefixer-rails'
# gem 'bootstrap-sass'
# add extra icon fonts
# gem 'font-awesome-sass'

# new some Cross Domain Help for the fonts
gem 'rack-cors'

# add a WISIWYG HTML editor for bootstrap
# gem 'bootstrap-wysihtml5-rails'
# gem 'trix'
# summernote directly added with js file
# gem 'summernote-rails'

# add datetime picker with bootstrap
# gem 'bootstrap-datepicker-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
# gem 'bootstrap-daterangepicker-rails'

# add full calendar to display and control events
gem 'fullcalendar-rails'
# gem 'momentjs-rails'

# use geocoder for addresse feed and other google maps tools with jquery.js
gem 'geocoder'

# render maps
gem 'gmaps4rails'
gem 'underscore-rails'

# use easy form templates with simple form
gem 'country_select'
gem 'simple_form'

# upload images
gem 'carrierwave'

# handle image manipulation
# gem 'mini_magick'
gem 'rmagick'
# grim help to make preview from pdf
gem 'grim'
# store in the cloud, in particular AWS
gem 'fog'

# button for social networks
gem 'social-share-button'

# use of Stripe as payment solution
gem 'oauth2'
gem 'stripe'

# add some graphing tools
gem 'chartkick'
gem 'groupdate'

# add admin
gem 'rails_admin'
gem 'rails_admin_rollincode', '~> 1.0'
# gem "wysiwyg-rails", "~> 1.2.7"

# New relic to monitor performances
gem 'newrelic_rpm'

# for Heroku
group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'tunemygc'
end

group :test do
  # provide one-line matchers to RSpec
  gem 'database_cleaner', '~> 1.5'
  gem 'shoulda-matchers', require: false

  # generating random data for the tests
  gem 'faker'
  # spring command line for rspec
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.5.2'
  # create objects needed in your tests which can include default values
  gem 'factory_girl_rails'
  # automation framework used for creating functional tests that simulates how users will interact
  gem 'capybara'

  # gem 'spring-commands-rspec', git: 'https://github.com/thewoolleyman/spring-commands-rspec.git'
  # START_HIGHLIGHT
  # this is a headless way to test instead of Selenium
  gem 'poltergeist'
  # END_HIGHLIGHT

  # gem 'selenium-webdriver'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # gem 'sqlite3'
  # gem 'i18n-tasks', '~> 0.9.5'

  # gem 'jasmine'
  # gem "teaspoon-jasmine"

  # BE CAREFULL there is a Article class that conflict with ArtiveRecord
  # gem 'brakeman', require: false
  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'

  # help debugging
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'

  # annotate the informations
  gem 'annotate'
  # use special markdown needed, in particular when using doc generated YARD
  gem 'kramdown', require: false

  # get UML
  # use bundle exec rake diagram:all_with_engines
  gem 'railroady'

  # look at
  # https://infinum.co/the-capsized-eight/articles/top-8-tools-for-ruby-on-rails-code-optimization-and-cleanup
  # memory usage
  # gem 'derailed_benchmarks'

  # the profiler used
  gem 'rack-mini-profiler', require: false
  # gem 'brakeman', :require => false
  # gem "rubycritic", :require => false

  gem 'i18n-tasks', '~> 0.9.5'
end
