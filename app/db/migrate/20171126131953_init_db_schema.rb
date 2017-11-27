class InitDbSchema < ActiveRecord::Migration[5.1]
  def up
    db_connection = ActiveRecord::Base.connection
    db_connection.execute(<<~UP_MIGRATION_SQL)
      CREATE TABLE posts (
        id bigserial PRIMARY KEY,
        title varchar(400) NOT NULL,
        content text NOT NULL,
        ip inet,
        author varchar(100) NOT NULL,
        average_rating real,
        number_of_ratings smallint NOT NULL DEFAULT 0
      );
      CREATE INDEX posts_average_rating_desc_index_index ON posts (average_rating DESC);
      CREATE TABLE ips (
        ip inet PRIMARY KEY,
        authors varchar(100)[]
      );
    UP_MIGRATION_SQL
  end

  def down
    db_connection = ActiveRecord::Base.connection
    db_connection.execute(<<~DOWN_MIGRATION_SQL)
      DROP TABLE IF EXISTS posts;
      DROP TABLE IF EXISTS ips;
    DOWN_MIGRATION_SQL
  end
end
