module IssueBadgeUserPreferencePatch
  def self.included(base) # :nodoc:
    base.send(:include, UserPreferenceInstanceMethodsForIssueBadge)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      after_destroy :destroy_issue_badge
    end
  end
end

module UserPreferenceInstanceMethodsForIssueBadge
  def issue_badge
    issue_badge = IssueBadgeUserSetting.find_by_user_id(user.id)
    return nil unless issue_badge
    issue_badge.enabled
  end

  def issue_badge=(enabled)
    issue_badge = IssueBadgeUserSetting.find_or_create_by_user_id(user.id)
    issue_badge.enabled = enabled
    issue_badge.save!
  end

  def destroy_issue_badge
    IssueBadgeUserSetting.destroy_by_user_id(user.id)
  end
end
