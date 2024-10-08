source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.1'
gem 'aws-sdk', '< 2.0'
gem 'aws-s3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 6.0.0.beta.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem "aws-sdk-s3", require: false

gem 'tailwindcss-rails', '2.0.30'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'sqlite3', '1.4.2'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# group :development, :test do
#   gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# end

# custom stuff
gem 'spree', '~> 4.1'
gem 'spree_api'
gem 'spree_backend'
gem 'spree_auth_devise', '~> 4.1'
gem 'spree_gateway', '~> 3.7'
gem 'spree_multi_vendor', github: 'umairrazam/spree_multi_vendor',branch:'stitchgrab'
#gem 'spree_multi_vendor', git: 'https://github.com/umairrazam/spree_multi_vendor.git', branch: 'stitchgrab'
gem 'spree_mail_settings', path: './spree_mail_settings'
gem 'spree_slider', github: 'spree-contrib/spree_slider'
gem 'rails_12factor', group: :production
gem 'spree_related_products', github: 'spree-contrib/spree_related_products'
gem 'onfleet-ruby'
gem 'mixpanel-ruby'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'spree_contact_us', github: 'spree-contrib/spree_contact_us'
gem 'spree_static_content', github: 'spree-contrib/spree_static_content'
gem 'ckeditor'
gem "mini_magick"
gem "autoprefixer-rails"
gem "stripe"
gem 'spree_chimpy', github: 'umairrazam/spree_chimpy', branch: "stitchgrab"
gem 'coffee-rails', '~> 5.0.0'
gem 'sidekiq', '~> 5.2.8'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'
