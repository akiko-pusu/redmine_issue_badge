# frozen_string_literal: true

namespace :redmine_issue_badge do
  desc 'Run spec for redmine_issue_badge plugin'
  task :spec do |task_name|
    next unless ENV['RAILS_ENV'] == 'test' && task_name.name == 'redmine_issue_badge:spec'

    begin
      require 'rspec/core'
      format = ENV['WERCKER_APPLICATION_NAME'].blank? ? 'NyanCatFormatter' : 'documentation'
      path = 'plugins/redmine_issue_badge/spec/'
      options = ['-I plugins/redmine_issue_badge/spec']
      options << '--color'
      options << '--tty'
      options << '--format'
      options << format
      options << path
      RSpec::Core::Runner.run(options)
    rescue LoadError => e
      puts "This task should be called only for redmine_issue_badge spec. #{e.message}"
    end
  end
end
