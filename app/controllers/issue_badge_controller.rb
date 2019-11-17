# frozen_string_literal: true

class IssueBadgeController < ApplicationController
  layout 'base'
  helper :issues
  menu_item :issues
  before_action :find_user

  def index
    all_issues_count = all_issues.size
    render action: '_issue_badge', layout: false,
           locals: { all_issues_count: all_issues_count, error_message: '',
                     badge_color: all_issues_count.zero? ? 'green' : 'red' }
  rescue ActiveRecord::RecordNotFound
    render action: '_issue_badge', layout: false,
           locals: { all_issues_count: '?', error_message: 'invalid_query_id', badge_color: 'red' }
  end

  def issues_count
    render(plain: { status: false }.to_json) && return if User.current.anonymous?

    all_issues_count = all_issues.count
    render plain: { status: true,
                    all_issues_count: all_issues_count,
                    badge_color: all_issues_count.zero? ? 'green' : 'red' }.to_json
  rescue ActiveRecord::RecordNotFound
    render plain: { status: false, error_message: 'invalid_query_id', badge_color: 'red' }.to_json
  end

  def load_badge_contents
    @query_id = setting.query_id if setting.try(:query_id).present?

    # noinspection RubyResolve
    begin
      condition = setting.newest? ? all_issues.reverse_order : all_issues
      @limited_issues = condition.includes(:project).limit(5)
    rescue ActiveRecord::RecordNotFound
      @limited_issues = []
      @error_message = 'invalid_query_id'
    end
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
    return all_issues_based_on_query if setting.try(:query_id).present?

    condition = [@user.id]
    condition += @user.group_ids if setting.show_assigned_to_group?
    Issue.joins(:project).visible.open.where(assigned_to_id: condition).merge(Project.active)
  end

  def all_issues_based_on_query
    query_id = setting.query_id
    query = IssueQuery.find_by!(id: query_id)
    @query_path = _project_issues_path(query.project, sort: 'priority:desc,updated_on:desc')
    Issue.joins(:project).visible.where(id: query.issues)
  end
end
