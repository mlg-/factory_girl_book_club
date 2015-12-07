require 'sinatra'
require 'sinatra/activerecord'

Dir['app/**/*.rb'].each { |file| require_relative file }
set :views, 'app/views'
set :environment, :development

get '/members' do
  @members = Member.all
  erb :index
end

get '/book_clubs/:id' do
  @book_club = BookClub.find(params[:id])
  erb :show
end
