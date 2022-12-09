# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob('data/*').map do |file|
    JSON.parse(File.open(file).read)
  end
  @memos = @memos.sort_by { |file| file['day_and_time'] }
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos/new' do
  memo = {
    "id": SecureRandom.uuid,
    "title": params['title'],
    "message": params['message'],
    "day_and_time": Time.now
  }
  File.open("data/#{memo[:id]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to('/memos')
end

get '/memos/:id' do
  path = "data/#{params[:id]}.json"
  memo = File.open(path) { |file| JSON.parse(file.read) }
  @title = memo['title']
  @message = memo['message']
  @id = memo['id']
  erb :detail
end

get '/memos/:id/edit' do
  path = "data/#{params[:id]}.json"
  memo = File.open(path) { |file| JSON.parse(file.read) }
  @title = memo['title']
  @message = memo['message']
  @id = memo['id']
  erb :edit
end

patch '/memos/:id/edit' do
  path = "data/#{params[:id]}.json"
  memo = {
    "id": params[:id],
    "title": params[:title],
    "message": params[:message],
    "day_and_time": Time.now
  }
  File.open(path, 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  path = "data/#{params[:id]}.json"
  File.delete(path)
  redirect to('/memos')
end
