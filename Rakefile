require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "process_monitor"
    gemspec.summary     = "A gem to monitor processes"
    gemspec.description = "This gem gets the status(running/sleeping/defunct) based on a pattern you provide to it. For example if you have a service which is running and its a ruby service you would need to pass the type(ruby) and a pattern which would identify the process."
    gemspec.email       = "sriram.varahan@gmail.com"
    gemspec.homepage    = "http://github.com/sriram/Process-Monitor"
    gemspec.authors     = ["Sriram Varahan"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  p "Jeweler not available. Install it with: gem install jeweler"
end
