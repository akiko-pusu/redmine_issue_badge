# frozen_string_literal: true

class IssueBadgeController < ApplicationController
  layout 'base'
  helper :issues
  menu_item :issues
  before_action :find_user, :all_issues, :define_limit

  def index
    all_issues_count = @query.issue_count

    render json: { status: true,
                   all_issues_count: all_issues_count,
                   badge_color: all_issues_count.zero? ? 'green' : 'red', content_path: content_path }
  rescue ActiveRecord::RecordNotFound
    render json: { all_issues_count: '?', error_message: 'invalid_query_id', badge_color: 'red' }
  end

  def issues_count
    render(plain: { status: false }.to_json) && return if User.current.anonymous?

    all_issues_count = @query.issue_count
    render json: { status: true,
                   all_issues_count: all_issues_count,
                   badge_color: all_issues_count.zero? ? 'green' : 'red', content_path: content_path }.to_json
  rescue ActiveRecord::RecordNotFound
    render json: { status: false, error_message: 'invalid_query_id', badge_color: 'red' }
  end

  def load_badge_contents
    # noinspection RubyResolve
    begin
      condition = setting.newest? ? "#{Issue.table_name}.id DESC" : "#{Issue.table_name}.id ASC"
      @limited_issues = @query.issues(limit: @limit, order: condition, include: %i[tracker assigned_to])
    rescue ActiveRecord::RecordNotFound
      @limited_issues = []
      @error_message = 'invalid_query_id'
    end
    render action: '_issue_badge_contents', layout: false, collection: @limited_issues, as: :issue
  end

  private

  def find_user
    @user = User.current
  end

  def define_limit
    @limit = Setting.plugin_redmine_issue_badge['number_to_display'] || 5
  end

  def setting
    IssueBadgeUserSetting.find_or_create_by_user_id(@user)
  end

  def all_issues
    return all_issues_based_on_query if setting.try(:query_id).present?

    condition = [@user.id]
    condition += @user.group_ids if setting.show_assigned_to_group?

    @query = IssueQuery.new(name: l(:label_assigned_to_me_issues), user: User.current)
    @query.add_filter 'assigned_to_id', '=', condition
    @query.add_filter 'project.status', '=', [Project::STATUS_ACTIVE.to_s]
  end

  def all_issues_based_on_query
    query_id = setting.query_id
    @query = IssueQuery.find_by!(id: query_id)
  end

  def content_path
    issue_badge_load_badge_contents_path
  end
end
