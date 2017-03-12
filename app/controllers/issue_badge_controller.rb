class IssueBadgeController < ApplicationController
  unloadable
  layout 'base'
  helper :issues
  include IssuesHelper
  menu_item :issues
  before_filter :find_user

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
    @limited_issues = all_issues.includes(:project).limit(5)
    render action: '_issue_badge_contents', layout: false
  end

  private

  def find_user
    @user = User.current
  end

  def setting
    IssueBadgeUserSetting.find_or_create_by_user_id(@user)
  end

  def all_issues
    condition = [@user.id]
    condition += @user.group_ids if setting.show_assigned_to_group?
    Issue.visible.open.where(assigned_to_id: condition)
  end
end
