namespace :redmine_issue_badge do
  desc 'Run test for redmine_issue_badge plugin.'
  task default: :spec

  desc 'Run spec for redmine_issue_badge plugin'
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = 'plugins/redmine_issue_badge/spec/**/*_spec.rb'
      t.rspec_opts = ['-I plugins/redmine_issue_badge/spec', '--format documentation']
    end
    task default: :spec
  rescue LoadError
    puts 'rspec failed.'
  end
end
