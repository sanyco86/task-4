require 'benchmark'

namespace :reload_json do
  task small: :environment do
    time = Benchmark.measure do
      Reload.new('fixtures/small.json').call
    end

    puts "TIME: #{time}"
  end

  task example: :environment do
    time = Benchmark.measure do
      Reload.new('fixtures/example.json').call
    end

    puts "TIME: #{time}"
  end

  task medium: :environment do
    time = Benchmark.measure do
      Reload.new('fixtures/medium.json').call
    end

    puts "TIME: #{time}"
  end

  task large: :environment do
    time = Benchmark.measure do
      Reload.new('fixtures/large.json').call
    end

    puts "TIME: #{time}"
  end
end
