# Benchmark.ips do |bench|
#   bench.report("Process small.json") do
#     Reload.new('fixtures/small.json').call
#   end
# end

class Reload
  SQL_DELETE_QUERY = <<-SQL.freeze
        DELETE FROM cities;
        DELETE FROM buses;
        DELETE FROM services;
        DELETE FROM trips;
        DELETE FROM buses_services;
  SQL

  def initialize(file_name)
    @file_name = file_name
  end

  def call
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute(SQL_DELETE_QUERY)

      Service::SERVICES.each do |service|
        query = "INSERT INTO services (name) VALUES ('#{service}') ON CONFLICT (name) DO NOTHING"
        ActiveRecord::Base.connection.execute(query)
      end

      json.each do |trip|
        ActiveRecord::Base.connection.execute(trips_sql(trip))
        buses_services_create(trip)
      end
    end
  end

  private
  attr_reader :file_name

  def json
    JSON.parse(File.read(file_name))
  end

  def buses_services_create(trip)
    trip['bus']['services'].each do |service|
      query = <<-SQL
        INSERT INTO buses_services (bus_id, service_id)
        VALUES (
          (SELECT id FROM buses WHERE number = '#{trip['bus']['number']}' AND model = '#{trip['bus']['model']}' LIMIT 1),
          (SELECT id FROM services WHERE name = '#{service}' LIMIT 1)
        )
        ON CONFLICT (bus_id, service_id) DO NOTHING
        RETURNING id
      SQL

      ActiveRecord::Base.connection.execute(query)
    end
  end

  def trips_sql(trip)
    <<-SQL
      INSERT INTO cities (name) VALUES ('#{trip['from']}') ON CONFLICT (name) DO NOTHING;
      INSERT INTO cities (name) VALUES ('#{trip['to']}')   ON CONFLICT (name) DO NOTHING;

      INSERT INTO buses (number, model)
      VALUES ('#{trip['bus']['number']}', '#{trip['bus']['model']}')
      ON CONFLICT (number) DO UPDATE SET model = EXCLUDED.model;

      INSERT INTO trips (from_id, to_id, start_time, duration_minutes, price_cents, bus_id)
      VALUES (
        (SELECT id FROM cities WHERE name = '#{trip['from']}' LIMIT 1),
        (SELECT id FROM cities WHERE name = '#{trip['to']}' LIMIT 1),
        '#{trip['start_time']}',
        '#{trip['duration_minutes']}',
        '#{trip['price_cents']}',
        (SELECT id FROM buses WHERE number = '#{trip['bus']['number']}')
      )
    SQL
  end
end
