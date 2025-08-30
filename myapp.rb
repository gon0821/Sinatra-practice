# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'

helpers do
  def load_memos
    File.write('memos.json', {}) unless File.exist?('memos.json')
    JSON.load_file('memos.json')
  end
end

helpers do
  def save_to_json(memos)
    File.open('memos.json', 'w') { |file| JSON.dump(memos, file) }
  end
end

get '/' do
  erb :home
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  new_id = memos.keys.last.to_i + 1
  memos[new_id.to_s] = params.slice(:title, :content)
  save_to_json(memos)

  redirect to('/memos/complete'), 303
end

get '/memos/complete' do
  erb :complete
end

get '/memos/:id' do
  memos = load_memos
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
  memos = load_memos
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
  memos = load_memos
  memos[params[:id]] = params.slice(:title, :content)
  save_to_json(memos)

  redirect to("/memos/#{params[:id]}"), 303
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete(params[:id])
  save_to_json(memos)

  redirect to('/memos'), 303
end

not_found do
  erb :not_found
end
