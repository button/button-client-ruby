require 'rake/testtask'
require 'rubocop/rake_task'

task default: [:test]
task test: [:unit, :lint]

Rake::TestTask.new(:unit) do |t|
  t.pattern = './test/**/*_test.rb'
end

RuboCop::RakeTask.new(:lint)
