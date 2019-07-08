# frozen_string_literal: true

class IssueBadgeController < ApplicationController
  layout 'base'
  helper :issues
  menu_item :issues
  before_action :find_user

  def index
    @all_issues_count = all_issues.size

    render action: '_issue_badge', layout: false
  end

  def issues_count
    render(plain: { status: false }.to_json) && return if User.current.anonymous?
    render plain: { status: true, all_issues_count: all_issues.count }.to_json
  end

  def load_badge_contents
    # noinspection RubyResolve
    condition = setting.newest? ? all_issues.reverse_order : all_issues
    @limited_issues = condition.includes(:project).limit(5)
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
    Issue.joins(:project).visible.open.where(assigned_to_id: condition).merge(Project.active)
  end
end
