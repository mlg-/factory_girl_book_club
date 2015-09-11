require 'sinatra'
require 'sinatra/activerecord'

Dir['app/**/*.rb'].each { |file| require_relative file }
set :views, 'app/views'
set :environment, :development
