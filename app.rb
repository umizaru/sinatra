# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

CONNECT = PG.connect(dbname: 'memoapp')

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = CONNECT.exec('SELECT * FROM memos ORDER BY id ASC')
  erb :memos
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  query = 'INSERT INTO memos(title, message) VALUES($1,$2)'
  values = [params[:title], params[:message]]
  @memo = CONNECT.exec(query, values)
  redirect to('/memos')
end

get '/memos/:id' do
  query = 'SELECT * FROM memos WHERE id = $1'
  values = [params[:id]]
  @memo = CONNECT.exec(query, values)
  @memo = @memo[0]
  erb :detail
end

get '/memos/:id/edit' do
  query = 'SELECT * FROM memos WHERE id = $1'
  values = [params[:id]]
  @memo = CONNECT.exec(query, values)
  @memo = @memo[0]
  erb :edit
end

patch '/memos/:id' do
  query = 'UPDATE memos SET title = $1, message = $2 WHERE id = $3'
  values = [params[:title], params[:message], params[:id]]
  @memo = CONNECT.exec(query, values)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  query = 'DELETE FROM memos WHERE id = $1'
  values = [params[:id]]
  @memo = CONNECT.exec(query, values)
  redirect to('/memos')
end
