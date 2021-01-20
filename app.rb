# frozen_string_literal: true

require 'sinatra'
require 'pathname'
require 'json'
require 'etc'
require './lib/crud_controller'

enable :method_override

get '/' do
  notes = read_main
  a_tags = to_link(sort_notes(notes))
  @notes_in_ul_tag = to_ul(a_tags)
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
  if file_exist?(params[:id])
    @note = read_note(params[:id])
    erb :show
  else
    erb :not_found
  end
end

get '/edit/note/:id' do
  if file_exist?(params[:id])
    @note = read_note(params[:id])
    erb :edit
  else
    erb :not_found
  end
end

patch '/note/:id' do
  if file_exist?(params[:id])
    update_main(params[:id], params[:title], params[:body])
    @notes = read_main
    redirect to('/')
  else
    erb :not_found
  end
end

delete '/note/:id' do
  if file_exist?(params[:id])
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

def to_link(notes)
  notes.map do |note|
    "<a href='/note/#{note['id']}'>#{justify_title(note['title'])}</a>"
  end
end

def to_ul(a_tags)
  li_tags = a_tags.map do |atag|
    "<li>#{atag}</li>"
  end.join

  "<ul>#{li_tags}</ul>"
end

helpers do
  def escape_processing(text)
    Rack::Utils.escape_html(text)
  end
end
