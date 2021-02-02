# frozen_string_literal: true

class CrudController
  def initialize(db_name, table_name)
    @connection = PG.connect(dbname: db_name)
    @table_name = table_name
    create_table unless table_exist?
  end

  def read_all_note
    read_all_query = "SELECT * FROM #{@table_name}"
    prepare_name = 'read_all_note'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, read_all_query)
    results = @connection.exec_prepared(prepare_name).map { |result| result }
    results.sort_by { |result| result.values_at('id') }.reverse
  end

  def read_note(id)
    read_note_query = "SELECT * FROM #{@table_name} WHERE id = $1"
    prepare_name = 'read_note'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, read_note_query)
    @connection.exec_prepared(prepare_name, [id]) { |result| result[0] }
  end

  def create_note(title, body)
    create_note_query = "INSERT INTO #{@table_name} (title, body) VALUES ($1, $2) RETURNING id"
    prepare_name = 'create_note'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, create_note_query)
    @connection.exec_prepared(prepare_name, [title, body]) { |result| result[0]['id'] }
  end

  def update_note(id, title, body)
    update_note_query = "UPDATE #{@table_name} SET (title, body) = ($2, $3) WHERE id = $1"
    prepare_name = 'update_note'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, update_note_query)
    @connection.exec_prepared(prepare_name, [id, title, body])
  end

  def delete_note(id)
    delete_note_query = "DELETE FROM #{@table_name} WHERE id = $1"
    prepare_name = 'delete_note'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, delete_note_query)
    @connection.exec_prepared(prepare_name, [id])
  end

  def id_exist?(id)
    if /^[0-9]+$/.match?(id)
      exist_id_query = "SELECT * FROM #{@table_name} WHERE id = $1"
      prepare_name = 'id_exist'
      delete_if_exist(prepare_name)
      @connection.prepare(prepare_name, exist_id_query)
      @connection.exec_prepared(prepare_name, [id]).cmd_tuples == 1
    else
      false
    end
  end

  private

  def prepare_exist?(prepare_name)
    tuple = @connection.exec("SELECT * FROM pg_prepared_statements WHERE name='#{prepare_name}'").cmd_tuples
    tuple.positive?
  end

  def delete_if_exist(prepare_name)
    @connection.exec("DEALLOCATE #{prepare_name}") if prepare_exist?(prepare_name)
  end

  def table_exist?
    exist_table_query = "SELECT table_name FROM information_schema.tables WHERE table_name = '#{@table_name}'"
    prepare_name = 'table_exist'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, exist_table_query)
    @connection.exec_prepared(prepare_name).cmd_tuples == 1
  end

  def create_table
    create_table_query = "CREATE TABLE #{@table_name} (id SERIAL, title TEXT NOT NULL, body TEXT)"
    prepare_name = 'create_table'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, create_table_query)
    @connection.exec_prepared(prepare_name)
  end
end
