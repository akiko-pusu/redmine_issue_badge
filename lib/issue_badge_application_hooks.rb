class IssueBadgeApplicationHooks < Redmine::Hook::ViewListener
  include ApplicationHelper

  def view_layouts_base_html_head(context = {})
    base_url = Redmine::Utils.relative_url_root
    badge_url = base_url + "/issue_badge"
    o = ''
    if User.current.logged?
      e = User.current.pref.issue_badge
      if e == true
        my_issue_count = Issue.visible.open.where(:assigned_to_id => ([User.current.id] + User.current.group_ids)).size
        o = stylesheet_link_tag('style', :plugin => 'redmine_issue_badge')
        o << javascript_include_tag('issue_badge', :plugin => 'redmine_issue_badge')
        o << "\n".html_safe + javascript_tag("load_badge('#{escape_javascript badge_url}');")
      end
    end
    return o
  end
end