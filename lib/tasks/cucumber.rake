namespace :xvfb do
  desc 'Start headlessly...'
  task :start do
    require 'headless'
    headless = Headless.new :display => 98
    headless.start
  end
end

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = ['--format pretty', '--tags ~@wip', '--tags ~@focus', 'features']
  end

  Cucumber::Rake::Task.new(:'features:wip') do |t|
    t.cucumber_opts = ['--format pretty', '--tags @wip', 'features']
  end

  Cucumber::Rake::Task.new(:'features:focus') do |t|
    t.cucumber_opts = ['--format pretty', '--tags ~@wip', '--tags @focus', 'features']
  end

  Cucumber::Rake::Task.new(:'features:all') do |t|
    t.cucumber_opts = ['--format pretty', 'features']
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

