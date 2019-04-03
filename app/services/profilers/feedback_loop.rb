class Profilers::FeedbackLoop
  def metric_prof
    Benchmark.ips do |bench|
      bench.report("Process small.json") do
        Reload.new('fixtures/small.json').call
      end
    end
  end

  def memory_prof
    report = MemoryProfiler.report do
      Reload.new('fixtures/small.json').call
    end
    report.pretty_print(scale_bytes: true)
  end

  def stack_prof
    StackProf.run(mode: :wall, out: 'tmp/stackprof.dump', raw: true) do
      Reload.new('fixtures/small.json').call
    end
  end

  def ruby_prof
    RubyProf.measure_mode = RubyProf::WALL_TIME

    result = RubyProf.profile do
      Reload.new('fixtures/small.json').call
    end

    printer = RubyProf::FlatPrinter.new(result)
    printer.print(File.open("tmp/ruby_prof_flat.txt", "w+"))

    printer2 = RubyProf::GraphHtmlPrinter.new(result)
    printer2.print(File.open("tmp/ruby_prof_graph.html", "w+"))

    printer3 = RubyProf::CallStackPrinter.new(result)
    printer3.print(File.open("tmp/ruby_prof_callstack.html", "w+"))

    printer4 = RubyProf::CallTreePrinter.new(result)
    printer4.print(:path => "tmp", :profile => 'callgrind')
  end
end
