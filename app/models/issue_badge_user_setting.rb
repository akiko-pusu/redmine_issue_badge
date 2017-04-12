class IssueBadgeUserSetting < ActiveRecord::Base
  unloadable
  belongs_to :user
  validates_presence_of :user
  attr_accessible :enabled, :show_assigned_to_group

  def self.find_or_create_by_user_id(user)
    issue_badge = IssueBadgeUserSetting.where(user_id: user.id).first
    unless issue_badge
      issue_badge = IssueBadgeUserSetting.new
      issue_badge.user = user
    end
    issue_badge
  end

  def self.destroy_by_user_id(user_id)
    issue_badge = IssueBadgeUserSetting.where(user_id: user_id).first
    issue_badge.destroy if issue_badge
  end

  def enabled?
    # noinspection RubyResolve
    enabled
  end

  def show_assigned_to_group?
    show_assigned_to_group
  end
end
