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

helpers do
  def filepath
    "data/#{File.basename(params[:id])}.json"
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Dir.glob('data/*').map do |path|
    JSON.parse(File.open(path).read)
  end
  @memos = @memos.sort_by { |memo| memo['day_and_time'] }
  erb :memos
end

get '/memos/new' do
  erb :new
end

post '/memos/new' do
  memo = {
    id: SecureRandom.uuid,
    title: params[:title],
    message: params[:message],
    day_and_time: Time.now
  }
  File.open("data/#{memo[:id]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect to('/')
end

get '/memos/:id' do
  @memo = File.open(filepath) { |file| JSON.parse(file.read) }
  erb :edit
end

get '/memos/:id/edit' do
  @memo = File.open(filepath) { |file| JSON.parse(file.read) }
  erb :detail
end

patch '/memos/:id' do
  memo = {
    id: params[:id],
    title: params[:title],
    message: params[:message],
    day_and_time: Time.now
  }
  if File.exist?(filepath)
    File.open(filepath, 'w') do |file|
      JSON.dump(memo, file)
    end
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  File.delete(filepath)
  redirect to('/memos')
end
