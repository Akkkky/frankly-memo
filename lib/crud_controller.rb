# frozen_string_literal: true

FILE_DIR = Pathname(__dir__).join('../public/notes')

def read_main
  file_path = FILE_DIR.join('*.json')
  notes = retrieve_json_file(file_path)
  a_tags = to_link(sort_notes(notes))
  to_ul(a_tags)
end

def retrieve_json_file(file_path)
  files_paths = Dir.glob(file_path)

  files_paths.map do |path_name|
    File.open(path_name) do |json_file|
      json_object = JSON.load(json_file)
      { 'id' => json_object['id'], 'title' => json_object['title'] }
    end
  end
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

def sort_notes(notes)
  notes.sort_by { |note| note.values_at('id') }.reverse
end

def justify_title(title)
  title.length > 19 ? "#{title[0..19]}…" : title
end

def read_note(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.open(file_path) do |json_file|
    JSON.load(json_file)
  end
end

def create_main(title, body)
  file_id = create_id
  file_path = FILE_DIR.join("#{file_id}.json")

  create_file(file_path, file_id, title, body)
  load_json_file(file_path)
end

def create_file(file_path, file_id, title, body)
  hash = { 'id' => file_id, 'title' => title, 'body' => body }
  open(file_path, 'w') do |file|
    JSON.dump(hash, file)
  end
end

def create_id
  Time.now.to_i
end

def load_json_file(file_path)
  File.open(file_path) do |json_file|
    JSON.load(json_file)
  end
end

def update_main(file_id, title, body)
  file_path = FILE_DIR.join("#{file_id}.json")
  hash = { 'id' => file_id.to_i, 'title' => title, 'body' => body }
  edit_file(file_path, hash)
end

def edit_file(file_path, hash)
  open(file_path, 'w') do |file|
    JSON.dump(hash, file)
  end
end

def is_file_exist(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.exist?(file_path)
end

def delete_file(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.delete(file_path) if File.exist?(file_path)
end