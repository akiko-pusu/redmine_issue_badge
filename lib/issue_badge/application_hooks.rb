# frozen_string_literal: true

module IssueBadge
  class ApplicationHooks < Redmine::Hook::ViewListener
    include ApplicationHelper

    def view_layouts_base_html_head(context = {})
      controller = context[:controller]
      o = ''
      if User.current.logged?
        global_enabled = Setting.plugin_redmine_issue_badge['activate_for_all_users'] == 'true'
        issue_badge = IssueBadgeUserSetting.find_or_create_by_user_id(User.current)
        o = stylesheet_link_tag('style', plugin: 'redmine_issue_badge')

        o << javascript_include_tag('issue_badge_my_preference', plugin: 'redmine_issue_badge') if my_preference_page?(controller)

        if issue_badge.try(:enabled?) || global_enabled
          o << javascript_include_tag('issue_badge', plugin: 'redmine_issue_badge')
          o << "\n".html_safe + javascript_tag(build_load_badge_script)
        end
      end
      o
    end

    def build_load_badge_script
      base_url = Redmine::Utils.relative_url_root
      badge_url = base_url + '/issue_badge'
      polling_option = Setting.plugin_redmine_issue_badge['enabled_polling'] == 'true'

      return "loadBadge('#{escape_javascript badge_url}');" unless polling_option

      "loadBadge('#{escape_javascript badge_url}', '#{issue_badge_issues_count_path}');"
    end

    def my_preference_page?(controller)
      return false unless controller&.class&.name == 'MyController'

      controller.action_name == 'account'
    end
  end
end
