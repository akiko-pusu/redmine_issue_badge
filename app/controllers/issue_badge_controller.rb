class IssueBadgeController < ApplicationController
  unloadable
  layout 'base'
  helper :issues
  include IssuesHelper
  menu_item :issues
  before_filter :find_user

  def index
    if badge_count().to_i ==0
      @all_issues_count = all_issues.count
    else
      @all_issues_count= Array.new
      @all_issues_path = Array.new
      @all_issues_title=Array.new
      @all_issues_color=Array.new
      for i in 0..badge_count().to_i
        if i==0
          condition = [@user.id]
          condition += @user.group_ids if setting.show_assigned_to_group?
          @all_issues_count[i] = Issue.visible.open.where(assigned_to_id: condition).count
          @all_issues_path[i] = issues_path(:set_filter => 1, :assigned_to_id => 'me', :sort => 'priority:desc,updated_on:desc')
          @all_issues_title[i] = 'assigned to me'
          @all_issues_color[i]= 'rgb(255,0,0)'
        elsif i==1
          @all_issues_count[i] = Issue.visible.open.where(author_id: condition).count
          @all_issues_path[i] = issues_path(:set_filter => 1, :author_id => 'me', :sort => 'priority:desc,updated_on:desc')
          @all_issues_title[i] = 'author is me'
          @all_issues_color[i]= 'rgb(0,255,0)'
        else
          @all_issues_count[i] = Issue.visible.open.where(author_id: condition, status_id: [4]).count
          @all_issues_path[i] = issues_path(:set_filter => 1, :author_id => 'me', :status_id=>4,  :sort => 'priority:desc,updated_on:desc')
          @all_issues_title[i] = 'author is me & status=4'
          @all_issues_color[i]= 'rgb(0,0,255)'
        end
      end
    end
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

  def badge_count
    Setting.plugin_redmine_issue_badge['other_badge_num'].blank? ? 0 : Setting.plugin_redmine_issue_badge['other_badge_num']
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
