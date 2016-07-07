# Patch for banner plugin. This affects in "plugin" action of Redmine Settings
# controller.
# Now banner plugin does not have own model(table). So, datetime informations
# are stored as string and required datetime validation by controller.
#
# TODO Store banner settings to banner's own model (table).
#
module IssueBadgeSettingsControllerPatch
  unloadable

  def self.included(base)
    base.send(:include, ClassMethods)
    base.class_eval do
      alias_method_chain(:plugin, :issue_badge)
    end
  end

  module ClassMethods
    def plugin_with_issue_badge
      return plugin_without_issue_badge unless params[:id] == 'redmine_issue_badge'
      @plugin = Redmine::Plugin.find(params[:id])

      @partial = @plugin.settings[:partial]
      @settings = Setting["plugin_#{@plugin.id}"]

      if request.post?
        begin
          # do nothing
        rescue
          # Argument Error
          # TODO: Exception will happen about 2038 problem. (Fixed on Ruby1.9)
          flash[:error] = 'error'
          redirect_to action: 'plugin', id: @plugin.id
          return
        end
      end

      # Continue to do default action
      render template: 'plugins/redmine_issue_badge/app/views/settings/redmine_issue_badge_plugin.html.erb'
      plugin_without_issue_badge
    end
  end
end
