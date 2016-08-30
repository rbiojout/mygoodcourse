source 'https://rubygems.org'


ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.3'
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# add some search with PostGres
gem 'pg_search', '~> 1.0.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# gem 'haml'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1.1'

# add some additional jquery
gem 'jquery-ui-rails', '~> 5.0.5'

# to solve problems with tough on ios
gem 'touchpunch-rails'

# to solve reloading of pages
gem 'jquery-turbolinks', '~> 2.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# add devise for the users
gem 'devise'

# add pagination helper for listing the data
gem 'will_paginate'
# add some order in the models for lists
gem 'acts_as_list'
# gem 'nested_form_fields'

# we want slugs for URL instead of numbers
gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

# better work for nested forms the ajax is explains in the project page
gem 'cocoon'


# add some CSS
# recommended to use Autoprefixer with Bootstrap to add browser vendor prefixes automatically.
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
# add extra icon fonts
gem 'font-awesome-sass', '~> 4.2.0'

# add a WISIWYG HTML editor for bootstrap
# gem 'bootstrap-wysihtml5-rails'
# gem 'trix'
# summernote directly added with js file
# gem 'summernote-rails'


# add datetime picker with bootstrap
#gem 'bootstrap-datepicker-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
# gem 'bootstrap-daterangepicker-rails'

# add full calendar to display and control events
gem 'momentjs-rails'
gem 'fullcalendar-rails'

# use geocoder for addresse feed and other google maps tools with jquery.js
gem 'geocoder'

# render maps
gem 'underscore-rails'
gem 'gmaps4rails'

# use easy form templates with simple form
gem 'simple_form'
gem "country_select"

# upload images
gem 'carrierwave'
# handle image manipulation
# gem 'mini_magick'
gem 'rmagick'
# grim help to make preview from pdf
gem 'grim'
# store in the cloud, in particular AWS
gem 'fog'

# handle file upload with javascript, in particular for progress bar
gem 'jquery-fileupload-rails'

# button for social networks
gem 'social-share-button'

# use of Stripe as payment solution
gem 'stripe'
gem 'oauth2'

# add some graphing tools
gem "chartkick"
gem 'groupdate'

# add admin
gem 'rails_admin'
#gem "wysiwyg-rails", "~> 1.2.7"

# for Heroku
group :production do
  gem 'rails_12factor'
  gem 'puma'
  gem 'tunemygc'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'sqlite3'
  #gem 'i18n-tasks', '~> 0.9.5'
end


group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # help debugging
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'

  # get UML
  gem 'railroady'

  # memory usage
  gem 'derailed_benchmarks'

  # the profiler used
  gem 'rack-mini-profiler', require: false
  #gem 'brakeman', :require => false
  # gem "rubycritic", :require => false

end





