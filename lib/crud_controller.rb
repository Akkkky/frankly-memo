# frozen_string_literal: true

FILE_DIR = Pathname(__dir__).join('../public/notes')

def read_main
  file_path = FILE_DIR.join('*.json')
  retrieve_json_file(file_path)
end

def retrieve_json_file(file_path)
  files_paths = Dir.glob(file_path)

  files_paths.map do |path_name|
    File.open(path_name) do |json_file|
      json_object = JSON.parse(json_file.read)
      { 'id' => escape_processing(json_object['id']), 'title' => escape_processing(json_object['title']) }
    end
  end
end

def sort_notes(notes)
  notes.sort_by { |note| note.values_at('id') }.reverse
end

def justify_title(title_string, max_byte_size)
  return_string = +''
  title_string.chars.each do |string|
    return_string.bytesize < max_byte_size ? return_string << string : break
  end

  return_string.bytesize <= max_byte_size ? return_string : "#{return_string}..."
end

def read_note(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.open(file_path) do |json_file|
    JSON.parse(json_file.read)
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
  File.open(file_path, 'w') do |file|
    JSON.dump(hash, file)
  end
end

def create_id
  Time.now.to_i
end

def load_json_file(file_path)
  File.open(file_path) do |json_file|
    JSON.parse(json_file.read)
  end
end

def update_main(file_id, title, body)
  file_path = FILE_DIR.join("#{file_id}.json")
  hash = { 'id' => file_id.to_i, 'title' => escape_processing(title), 'body' => escape_processing(body) }
  edit_file(file_path, hash)
end

def edit_file(file_path, hash)
  File.open(file_path, 'w') do |file|
    JSON.dump(hash, file)
  end
end

def file_exist?(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.exist?(file_path)
end

def delete_file(id)
  file_path = FILE_DIR.join("#{id}.json")
  File.delete(file_path) if File.exist?(file_path)
end
