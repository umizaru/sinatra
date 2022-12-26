# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

CONNECT = PG.connect(
  dbname: 'memoapp'
)

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = CONNECT.exec('SELECT * FROM memoapp')
  erb :memos
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  query = 'INSERT INTO memoapp(title, message) VALUES($1,$2)'
  key = [params[:title], params[:message]]
  @memo = CONNECT.exec(query, key)
  redirect to('/memos')
end

get '/memos/:id' do
  query = 'SELECT * FROM memoapp WHERE id = $1'
  key = [params[:id]]
  @memo = CONNECT.exec(query, key)
  erb :detail
end

get '/memos/:id/edit' do
  query = 'SELECT * FROM memoapp WHERE id = $1'
  key = [params[:id]]
  @memo = CONNECT.exec(query, key)
  erb :edit
end

patch '/memos/:id' do
  query = 'UPDATE memoapp SET title = $1, message = $2 WHERE id = $3'
  key = [params[:title], params[:message], params[:id]]
  @memo = CONNECT.exec(query, key)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  query = 'DELETE FROM memoapp WHERE id = $1'
  key = [params[:id]]
  @memo = CONNECT.exec(query, key)
  redirect to('/memos')
end
