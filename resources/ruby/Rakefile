require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/euler'
  t.test_files = FileList['test/Test*.rb']
  t.verbose = true
end

task :default => :test