require 'redmine'
require 'issue_badge_application_hooks'
require 'issue_badge_my_account_hooks'
require 'issue_badge_user_preference_patch'

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  require_dependency 'user_preference'
  unless UserPreference.included_modules.include? IssueBadgeUserPreferencePatch
    UserPreference.send(:include, IssueBadgeUserPreferencePatch)
  end
end

Redmine::Plugin.register :redmine_issue_badge do
  name 'Redmine Issue Badge plugin'
  author 'Akiko Takano'
  description 'Plugin to show the number of assigned issues with badge on top menu.'
  version '0.0.2'
  url 'https://github.com/akiko-pusu/redmine_issue_badge'
  author_url 'http://twitter.com/akiko_pusu'
  requires_redmine :version_or_higher => '2.5.0'
end
