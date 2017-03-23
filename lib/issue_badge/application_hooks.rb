module IssueBadge
  class ApplicationHooks < Redmine::Hook::ViewListener
    include ApplicationHelper

    def view_layouts_base_html_head(_context = {})
      base_url = Redmine::Utils.relative_url_root
      badge_url = base_url + '/issue_badge'
      o = ''
      if User.current.logged?
        global_enabled = Setting.plugin_redmine_issue_badge['activate_for_all_users'] == 'true'
        issue_badge = IssueBadgeUserSetting.find_or_create_by_user_id(User.current)
        o = stylesheet_link_tag('style', plugin: 'redmine_issue_badge')
        if issue_badge.try(:enabled) || global_enabled
          o << javascript_include_tag('issue_badge', plugin: 'redmine_issue_badge')
          o << "\n".html_safe + javascript_tag("load_badge('#{escape_javascript badge_url}');")
        end
      end
      o
    end
  end
end
