# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'pg'
require 'dotenv/load'

configure do
  set :conn, PG.connect(
    host: ENV['POSTGRES_HOST'],
    port: ENV['POSTGRES_PORT'],
    dbname: 'memo_app',
    user: ENV['POSTGRES_USER'],
    password: ENV['POSTGRES_PASSWORD']
  )
end

helpers do
  def execute_sql(sql, params = [])
    settings.conn.exec_params(sql, params)
  end
end

helpers do
  def setup_database_table
    sql = 'CREATE TABLE IF NOT EXISTS memos (id SERIAL PRIMARY KEY, title VARCHAR(100) NOT NULL, content TEXT)'
    execute_sql(sql)
  end
end

before do
  setup_database_table
end

get '/' do
  erb :home
end

get '/memos' do
  @memos = execute_sql('SELECT * FROM memos ORDER BY id DESC')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  execute_sql('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])

  redirect to('/memos/complete'), 303
end

get '/memos/complete' do
  erb :complete
end

get '/memos/:id' do
  @id = params[:id]
  @memo = execute_sql('SELECT * FROM memos WHERE id = $1', [@id]).first
  if @memo
    erb :show
  else
    status 404
    erb :not_found
  end
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = execute_sql('SELECT * FROM memos WHERE id = $1', [@id]).first
  if @memo
    erb :edit
  else
    status 404
    erb :not_found
  end
end

patch '/memos/:id' do
  execute_sql('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [params[:title], params[:content], params[:id]])

  redirect to("/memos/#{params[:id]}"), 303
end

delete '/memos/:id' do
  execute_sql('DELETE FROM memos WHERE id = $1', [params[:id]])

  redirect to('/memos'), 303
end

not_found do
  erb :not_found
end
