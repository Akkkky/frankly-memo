# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pathname'
require 'json'
require 'etc'
require './lib/crud_controller'

enable :method_override

get '/' do
  @notes = read_main
  erb :top
end

get '/compose' do
  erb :compose
end

post '/compose' do
  create_main(escape_processing(params[:title]), escape_processing(params[:body]))
  @notes = read_main
  redirect to('/')
end

get '/note/:id' do
  if is_file_exist(params[:id])
    @note = read_note(params[:id])
    erb :show
  else
    erb :not_found
  end
end

get '/edit/note/:id' do
  if is_file_exist(params[:id])
    @note = read_note(params[:id])
    erb :edit
  else
    erb :not_found
  end
end

patch '/note/:id' do
  if is_file_exist(params[:id])
    update_main(params[:id], params[:title], params[:body])
    @notes = read_main
    redirect to('/')
  else
    erb :not_found
  end
end

delete '/note/:id' do
  if is_file_exist(params[:id])
    @note = read_note(params['id'])
    delete_file(params[:id])
    @notes = read_main
    redirect to('/')
  else
    erb :not_found
  end
end

not_found do
  erb :not_found
end

helpers do
  def escape_processing(test)
    Rack::Utils.escape_html(test)
  end
end
