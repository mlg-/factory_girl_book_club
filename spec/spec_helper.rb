require 'pry'
require 'rspec'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl'

require_relative '../app.rb'
require_relative 'support/factories'

set :environment, :test

Capybara.app = Sinatra::Application

ActiveRecord::Base.logger = nil
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
