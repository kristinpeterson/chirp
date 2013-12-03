class AddSearchVectorToUsers < ActiveRecord::Migration
  def up
    # 1. Create the search vector column
    add_column :users, :search_vector, 'tsvector'

    # 2. Create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX users_search_idx
      ON users
      USING gin(search_vector);
    SQL

    # 4 (optional). Trigger to update the vector column 
    # when the users table is updated
    execute <<-SQL
      DROP TRIGGER IF EXISTS users_search_vector_update
      ON users;
      CREATE TRIGGER users_search_vector_update
      BEFORE INSERT OR UPDATE
      ON users
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger (search_vector, 'pg_catalog.english', email, name);
    SQL

    Micropost.find_each { |p| p.touch }
  end

  def down
    remove_column :users, :search_vector
    execute <<-SQL
      DROP TRIGGER IF EXISTS users_search_vector_update on users;
    SQL
  end
end
