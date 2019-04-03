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
# Calculating -------------------------------------
# Process small.json      0.045  (± 0.0%) i/s -      1.000  in  22.001127s

#last run
#Calculating -------------------------------------
# Process small.json      0.237  (± 0.0%) i/s -      2.000  in   8.430203s

