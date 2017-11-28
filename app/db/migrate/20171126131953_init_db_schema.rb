class InitDbSchema < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    execute("ALTER SYSTEM SET max_connections = '100';")
    execute("ALTER SYSTEM SET shared_buffers = '1GB';")
    execute("ALTER SYSTEM SET effective_cache_size = '3GB';")
    execute("ALTER SYSTEM SET work_mem = '10485kB';")
    execute("ALTER SYSTEM SET maintenance_work_mem = '256MB';")
    execute("ALTER SYSTEM SET min_wal_size = '1GB';")
    execute("ALTER SYSTEM SET max_wal_size = '2GB';")
    execute("ALTER SYSTEM SET checkpoint_completion_target = '0.7';")
    execute("ALTER SYSTEM SET wal_buffers = '16MB';")
    execute("ALTER SYSTEM SET default_statistics_target = '100';")
    execute("SELECT pg_reload_conf();")
    execute(<<~UP_MIGRATION_SQL)
      BEGIN;
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
      COMMIT;
    UP_MIGRATION_SQL
  end

  def down
    execute(<<~DOWN_MIGRATION_SQL)
      DROP TABLE IF EXISTS posts;
      DROP TABLE IF EXISTS ips;
    DOWN_MIGRATION_SQL
  end
end
