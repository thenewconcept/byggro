source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.1"

gem "acts_as_list", "~> 1.0"
gem "active_link_to", "~> 1.0"
gem "sprockets-rails"
gem "google-cloud-storage"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "pundit", "~> 2.1"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "bcrypt", "~> 3.1.7"
gem "image_processing", "~> 1.2"
gem "harvesting", "~> 0.5.1"
gem "heroicon", "~> 0.4.0"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Sass to process CSS
# gem "sassc-rails"

group :development, :test do
  gem 'byebug'
  gem 'pry'

  gem 'faker'
  gem 'factory_bot_rails'
  gem 'rspec-rails'

  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-docmore'
end

group :development do
  gem "web-console"
  gem "hotwire-livereload"
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem "where_exists", "~> 2.0"
