source 'https://rubygems.org'

ruby "2.3.1"

gem 'rails', '4.2.6'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem "factory_girl_rails"
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem "letter_opener"
end

group :test do
  gem "timecop"
  gem "pundit-matchers", "~> 1.1.0"
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
  gem "puma_worker_killer"
end

# added general gem
gem "slim-rails"
gem "bootstrap-sass", "~> 3.3.6"
gem "simple_form"
gem "clearance"
gem "activerecord-postgis-adapter"
gem "dotenv-rails"
gem "kaminari"
gem "pickadate-rails"
gem "faker"
gem "acts-as-taggable-on", "~> 3.4"
gem "refile", github: "refile/refile", require: ["refile/rails", "refile/simple_form"]
gem "refile-mini_magick"
gem "refile-s3"
gem "font_assets"
gem "cocoon"
gem "tod"
gem "jquery-inputmask-rails", github: "knapo/jquery-inputmask-rails"
gem "newrelic_rpm"
gem "acts_as_votable"
gem "rack-timeout"
gem "sucker_punch", "~> 2.0"
gem "textacular", "~> 3.0"
gem "pundit"
gem "ransack"
gem "select2-rails"
gem "koala", "~> 2.2"
gem "foursquare2"
gem "validates_timeliness", "~> 4.0"
gem "email_spec"
