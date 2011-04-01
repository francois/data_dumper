module DataDumper
  def self.dump(path)
    ActiveRecord::Base.connection.tables.each do |table_name|
      quoted_output_filename = ActiveRecord::Base.connection.quote(File.expand_path(File.join(path, table_name + ".sql")))
      ActiveRecord::Base.connection.execute(<<-EOSQL)
        COPY #{table_name} TO #{quoted_output_filename} WITH CSV
      EOSQL
    end
  end

  def self.load(path)
    conn = ActiveRecord::Base.connection
    ActiveRecord::Base.transaction do
      files = Dir[File.join(path, "*.sql")]

      puts "Disabling triggers in all tables to be loaded"
      files.each do |filename|
        table_name = File.basename(filename, ".sql")
        conn.execute "ALTER TABLE #{table_name} DISABLE TRIGGER ALL"
      end

      puts "Truncating existing data"
      table_names = files.map do |filename|
        File.basename(filename, ".sql")
      end
      conn.execute "TRUNCATE #{table_names.join(", ")} CASCADE"

      puts "Loading new data from #{path.inspect}..."
      files.each do |filename|
        # Has to be absolute, since it's the server process itself which will load the data
        quoted_filename = conn.quote(File.expand_path(filename))
        table_name      = File.basename(filename, ".sql")

        puts table_name
        conn.execute "COPY #{table_name} FROM #{quoted_filename} CSV"
      end

      puts "Enabling triggers in all tables"
      files.each do |filename|
        table_name = File.basename(filename, ".sql")
        conn.execute "ALTER TABLE #{table_name} ENABLE TRIGGER ALL"
      end

    end

    puts "Analyzing the data, for best performance"
    conn.execute "ANALYZE"
  end
end
