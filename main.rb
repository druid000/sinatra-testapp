require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'erb'


DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/test.db")

set :port, 8000

get '/id/:name' do 
    @name = params[:name]
	erb :reg
end 


post '/loop' do 
    @thing = params[:numbers]
    erb :result
end
    
####################

class Note
include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :done, Boolean, :required => true, :default => 0
	property :made_at, DateTime
	property :updated_at, DateTime
end

DataMapper.auto_upgrade!


post '/' do
	n = Note.new
	n.content = params[:content]
	n.made_at = Time.now
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id' do
	@note = Note.get params[:id]
	@title = "Modify ##{params[:id]}"
	erb :modify
end

put '/:id' do
	n = Note.get params[:id]
	n.content = params[:content]
	n.done = params[:done] ? 1 : 0
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id/delete' do
	@note = Note.get params[:id]
	@title = " Delete ##{params[:id]}"
	erb :delete
end

delete '/:id' do
	n = Note.get params[:id]
	n.destroy
end

get '/:id/done' do
	n = Note.get params[:id]
	n.done = n.done ? 0 : 1 
	n.updated_at = Time.now
	n.save
end
