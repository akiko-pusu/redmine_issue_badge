class IssueBadgeController < ApplicationController
  unloadable
  layout 'base'
  helper :issues
  include IssuesHelper
  menu_item :issues

  def index
    # noinspection RubyResolve
    all_issues = Issue.visible.open.where(:assigned_to_id => ([User.current.id] + User.current.group_ids))
    @all_issues_count = all_issues.count
    render :action => '_issue_badge', :layout => false
  end

  def load_badge_contents
    # noinspection RubyResolve
    @limited_issues = Issue.visible.open.where(:assigned_to_id => ([User.current.id] + User.current.group_ids)).limit(5)
    render :action => '_issue_badge_contents', :layout => false
  end

  private
  def find_user
    @user = User.current
  end
end

