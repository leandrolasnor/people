# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

gem "active_model_serializers"

gem "dry-container"

gem "dry-transaction"

gem "dry-monads"

gem "dry-initializer"

gem "dry-validation"

gem "pg"

gem "sidekiq"

gem "meilisearch-rails"

gem "kaminari"

gem "paranoia"

gem "prawn"

gem "prawn-table"

gem "prawn-icon"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "bullet"
  gem "factory_bot_rails"
  gem "faker", github: "faker-ruby/faker"
  gem "guard-rspec", require: false
  gem 'parallel_tests'
  gem "rspec"
  gem "rspec-rails"
  gem "rswag"
  gem "rswag-specs"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "sse-client"
  gem "timecop"
  gem "webmock"
  gem "foreman"
end

group :development do
  gem "letter_opener"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

