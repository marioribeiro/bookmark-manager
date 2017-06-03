ENV["RACK_ENV"] = "test"

require 'capybara/rspec'
require 'database_cleaner'
require './app/app'
require_relative 'helpers/session'
require 'web_helper'


Capybara.app = BookmarkManager

RSpec.configure do |config|

  config.include SessionHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
