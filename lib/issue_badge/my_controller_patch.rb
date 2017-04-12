module IssueBadge
  module MyControllerPatch
    extend ActiveSupport::Concern
    unloadable
    included do
      alias_method_chain(:account, :issue_badge)
    end

    def account_with_issue_badge
      user = User.current
      @issue_badge = IssueBadgeUserSetting.find_or_create_by_user_id(user)
      if request.post?
        begin
          unless @issue_badge.update(badge_params)
            logger.warn "Can't save IssueBadge."
          end
        rescue => ex
          logger.warn "Can't save IssueBadge. #{ex.message}"
        end
      end
      account_without_issue_badge
    end

    private

    def badge_params
      params.require(:issue_badge).permit(:enabled, :show_assigned_to_group)
    end
  end
end
