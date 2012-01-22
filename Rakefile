require 'rake'
require 'rake/testtask'

desc "run a development server"
task :run do
  `shotgun app.rb`
end

Rake::TestTask.new do |t|
  t.libs << "."
  t.libs << "lib"
  t.test_files = FileList[ "test/diff_test.rb", "test/app_test.rb" ]
end
