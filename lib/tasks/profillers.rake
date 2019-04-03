namespace :prof do
  task metric_prof: :environment do
    Profilers::FeedbackLoop.new.metric_prof
  end

  task memory_prof: :environment do
    Profilers::FeedbackLoop.new.memory_prof
  end

  task stack_prof: :environment do
    # stackprof tmp/stackprof.dump --text --limit 5
    # stackprof tmp/stackprof.dump --method 'Object#method'
    Profilers::FeedbackLoop.new.stack_prof
  end

  task ruby_prof: :environment do
    Profilers::FeedbackLoop.new.ruby_prof
  end

  task asymptotics: :environment do
    Profilers::FeedbackLoop.new.asymptotics
  end
end

# first run
# Process small.json  22.001127s

#before tune postgres run
# Process small.json  8.430203s

#after tune postgres run
# Process small.json 4.182239s
