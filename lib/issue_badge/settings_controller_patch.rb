# Patch for banner plugin. This affects in "plugin" action of Redmine Settings
# controller.
module IssueBadge
  module SettingsControllerPatch
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
end
