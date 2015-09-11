require "./app"
require "sinatra/activerecord/rake"
require "rspec/core/rake_task"

begin
  Rake::Task["db:migrate"].enhance do
    Rake::Task["db:test:prepare"].invoke
  end
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts "Please 'bundle', first."
end

