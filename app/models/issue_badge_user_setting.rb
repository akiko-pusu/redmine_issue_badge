# frozen_string_literal: true

class IssueBadgeUserSetting < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  include Redmine::SafeAttributes
  belongs_to :user
  validates :user, presence: true
  safe_attributes 'enabled', 'show_assigned_to_group'

  enum badge_order: { oldest: 0, newest: 1 }
  scope :enabled, -> { where(enabled: true) }
  scope :show_assigned_to_group, -> { where(show_assigned_to_group: true) }

  def enabled?
    # noinspection RubyResolve
    enabled
  end

  def show_assigned_to_group?
    show_assigned_to_group
  end

  #
  # Class method
  #
  class << self
    def find_or_create_by_user_id(user)
      issue_badge = IssueBadgeUserSetting.find_by(user_id: user.id)
      unless issue_badge
        issue_badge = IssueBadgeUserSetting.new
        issue_badge.user = user
      end
      issue_badge
    end

    def destroy_by_user_id(user_id)
      issue_badge = IssueBadgeUserSetting.find_by(user_id: user_id)
      issue_badge&.destroy
    end
  end
end
