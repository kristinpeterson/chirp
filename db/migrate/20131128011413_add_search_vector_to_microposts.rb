class AddSearchVectorToMicroposts < ActiveRecord::Migration
  def up
    # 1. Create the search vector column
    add_column :microposts, :search_vector, 'tsvector'

    # 2. Create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX microposts_search_idx
      ON microposts
      USING gin(search_vector);
    SQL

    # 4 (optional). Trigger to update the vector column 
    # when the microposts table is updated
    execute <<-SQL
      DROP TRIGGER IF EXISTS microposts_search_vector_update
      ON microposts;
      CREATE TRIGGER microposts_search_vector_update
      BEFORE INSERT OR UPDATE
      ON microposts
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger (search_vector, 'pg_catalog.english', content);
    SQL

    Micropost.find_each { |p| p.touch }
  end

  def down
    remove_column :microposts, :search_vector
    execute <<-SQL
      DROP TRIGGER IF EXISTS microposts_search_vector_update on microposts;
    SQL
  end
end
