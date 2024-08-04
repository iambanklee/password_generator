# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in password_generator.gemspec
gemspec

gem "rake", "~> 13.0"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "guard"
  gem "guard-rspec"
  gem "rspec"
  gem 'rubocop', require: false
  gem "simplecov"
end
