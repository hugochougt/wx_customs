# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in wx_customs.gemspec
gemspec

group :development, :test do
  # A make-like build utility for Ruby.
  # https://github.com/ruby/rake
  gem "rake", "~> 12.0"

  # minitest provides a complete suite of testing facilities supporting TDD, BDD, mocking, and benchmarking.
  # https://github.com/seattlerb/minitest
  gem "minitest", "~> 5.0"

  # Step-by-step debugging and stack navigation in Pry
  # https://github.com/deivid-rodriguez/pry-byebug
  gem "pry-byebug", "~> 3.9"
end

group :development do
  # A Ruby static code analyzer and formatter, based on the community Ruby style guide
  # https://github.com/rubocop-hq/rubocop
  gem "rubocop", "~> 0.92.0", require: false
end

group :test do
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  # https://github.com/bblimke/webmock
  gem "webmock", "~> 3.9", ">= 3.9.1"
end
