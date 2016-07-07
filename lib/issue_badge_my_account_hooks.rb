class IssueBadgeMyAccountHooks < Redmine::Hook::ViewListener
  render_on :view_my_account, partial: 'my/issue_badge_form', multipart: true
end
