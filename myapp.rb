# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'

get '/' do
  erb :home
end

get '/memos' do
  @memos = JSON.load_file('memos.json')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = JSON.load_file('memos.json')
  new_id = memos.keys.last.to_i + 1
  memos[new_id.to_s] =
    {
      'title' => params[:title],
      'content' => params[:content]
    }
  File.open('memos.json', 'w') { |file| JSON.dump(memos, file) }

  redirect to('/memos/complete'), 303
end

get '/memos/complete' do
  erb :complete
end

get '/memos/:id' do
  memos = JSON.load_file('memos.json')
  @id = params[:id]
  @memo = memos[@id]
  if @memo
    erb :show
  else
    status 404
    erb :not_found
  end
end

get '/memos/:id/edit' do
  memos = JSON.load_file('memos.json')
  @id = params[:id]
  @memo = memos[@id]
  if @memo
    erb :edit
  else
    status 404
    erb :not_found
  end
end

patch '/memos/:id' do
  memos = JSON.load_file('memos.json')
  memos[params[:id]] =
    {
      'title' => params[:title],
      'content' => params[:content]
    }
  File.open('memos.json', 'w') { |file| JSON.dump(memos, file) }

  redirect to("/memos/#{params[:id]}"), 303
end

delete '/memos/:id' do
  memos = JSON.load_file('memos.json')
  memos.delete(params[:id])
  File.open('memos.json', 'w') { |file| JSON.dump(memos, file) }

  redirect to('/memos'), 303
end

not_found do
  erb :not_found
end
