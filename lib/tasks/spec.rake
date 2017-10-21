namespace :redmine_issue_badge do
  desc 'Run spec for redmine_issue_badge plugin'
  task :spec do |task_name|
    next unless ENV['RAILS_ENV'] == 'test' && task_name.name == 'redmine_issue_badge:spec'
    begin
      require 'rspec/core'
      path = 'plugins/redmine_issue_badge/spec/'
      options = ['-I plugins/redmine_issue_badge/spec']
      options << '--format'
      options << 'NyanCatFormatter'
      options << path
      RSpec::Core::Runner.run(options)
    rescue LoadError => ex
      puts "This task should be called only for redmine_issue_badge spec. #{ex.message}"
    end
  end
end
