$LOAD_PATH.unshift File.dirname(__FILE__)

desc 'run tests'
task :test do
  Dir.chdir 'test'
  Dir['test_*.rb'].each do |test|
    load test
  end
end

task default: :test
