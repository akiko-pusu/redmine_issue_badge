require 'redmine'
require 'issue_badge/application_hooks'
require 'issue_badge/my_account_hooks'
require 'issue_badge/my_controller_patch'

Rails.configuration.to_prepare do
  require_dependency 'my_controller'
  unless MyController.included_modules.include? IssueBadge::MyControllerPatch
    MyController.include IssueBadge::MyControllerPatch
  end
end

Redmine::Plugin.register :redmine_issue_badge do
  name 'Redmine Issue Badge plugin'
  author 'Akiko Takano'
  description 'Plugin to show the number of assigned issues with badge on top menu.'
  version '0.0.6'
  url 'https://github.com/akiko-pusu/redmine_issue_badge'
  author_url 'http://twitter.com/akiko_pusu'
  requires_redmine version_or_higher: '3.3.0'

  settings partial: 'settings/redmine_issue_badge',
           default: {
             'activate_for_all_users' => 'false',
             'enabled_polling' => false
           }
end
