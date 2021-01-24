# frozen_string_literal: true

require 'sinatra'
require 'pg'
require './lib/crud_controller'

enable :method_override

my_db = CrudController.new

get '/' do
  notes = my_db.read_all_note
  a_tags = to_link(notes)
  @notes_in_ul_tag = to_ul(a_tags)
  erb :top
end

get '/compose' do
  erb :compose
end

post '/compose' do
  my_db.create_note(params[:title], params[:body])
  @notes = my_db.read_all_note
  redirect to('/')
end

get '/note/:id' do
  if my_db.id_exist?(params[:id])
    @note = my_db.read_note(params[:id])
    erb :show
  else
    erb :not_found
  end
end

get '/edit/note/:id' do
  if my_db.id_exist?(params[:id])
    @note = my_db.read_note(params[:id])
    erb :edit
  else
    erb :not_found
  end
end

patch '/note/:id' do
  if my_db.id_exist?(params[:id])
    my_db.update_note(params[:id], params[:title], params[:body])
    @notes = my_db.read_all_note
    redirect to('/')
  else
    erb :not_found
  end
end

delete '/note/:id' do
  if my_db.id_exist?(params[:id])
    my_db.delete_note(params[:id])
    @notes = my_db.read_all_note
    redirect to('/')
  else
    erb :not_found
  end
end

not_found do
  erb :not_found
end

helpers do
  def to_link(notes)
    notes.map do |note|
      title = justify_title(note['title'], 40)
      "<a href='/note/#{note['id']}'>#{escape_html(title)}</a>"
    end
  end

  def to_ul(a_tags)
    li_tags = a_tags.map do |atag|
      "<li>#{atag}</li>"
    end.join

    "<ul>#{li_tags}</ul>"
  end

  def justify_title(title_string, max_byte_size)
    return_string = +''
    title_string.chars.each do |string|
      return_string.bytesize < max_byte_size ? return_string << string : break
    end

    return_string.bytesize <= title_string.bytesize - 3 ? "#{return_string}..." : return_string
  end

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end
