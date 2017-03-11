class IssueBadgeController < ApplicationController
  unloadable
  layout 'base'
  helper :issues
  include IssuesHelper
  menu_item :issues

  def index
    @all_issues_count = all_issues.count
    render action: '_issue_badge', layout: false
  end

  def issues_count
    render(text: { status: false }.to_json) && return if User.current.anonymous?
    render text: { status: true, all_issues_count: all_issues.count }.to_json
  end

  def load_badge_contents
    # noinspection RubyResolve
    @limited_issues = all_issues.limit(5)
    render action: '_issue_badge_contents', layout: false
  end

  private

  def all_issues
    Issue.visible.open.where(assigned_to_id: ([User.current.id] + User.current.group_ids))
  end
end
