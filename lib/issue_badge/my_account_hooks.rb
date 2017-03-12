module IssueBadge
  class MyAccountHooks < Redmine::Hook::ViewListener
    render_on :view_my_account_preferences, partial: 'my/issue_badge_form', multipart: true
  end
end
