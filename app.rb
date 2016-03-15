require 'sinatra'
require 'sinatra/activerecord'

Dir['app/**/*.rb'].each { |file| require_relative file }
set :views, 'app/views'
set :environment, :development

get '/members' do
  @members = Member.all
  erb :index
end

get '/book_club/:id' do
  @book_club = BookClub.find(params[:id])
  @book_club_members = @book_club.members
  @leader = @book_club_members.find_by(leader: true)

  erb :book_club
end
