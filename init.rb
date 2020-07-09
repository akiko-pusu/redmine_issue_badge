# frozen_string_literal: true

# Redmine Issue Badge Plugin
#
# This is a plugin for Redmine to show how many issues are assigned to me via badge.
# Created by Akiko Takano.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

require 'redmine'
require 'issue_badge/application_hooks'
require 'issue_badge/my_account_hooks'
require 'issue_badge/my_controller_patch'

# NOTE: Keep error message for a while to support Redmine3.x users.
def issue_badge_version_message(original_message = nil)
  <<-"USAGE"
  ==========================
  #{original_message}
  If you use Redmine3.x, please use Redmine Issue Badge version 0.0.7 or clone via
  'support-Redmine3' branch.
  You can download older version from here: https://github.com/akiko-pusu/redmine_issue_badge/releases
  ==========================
  USAGE
end

Redmine::Plugin.register :redmine_issue_badge do
  begin
    name 'Redmine Issue Badge plugin'
    author 'Akiko Takano'
    description 'Plugin to show the number of assigned issues with badge on top menu.'
    version '0.1.4'
    url 'https://github.com/akiko-pusu/redmine_issue_badge'
    author_url 'http://twitter.com/akiko_pusu'
    requires_redmine version_or_higher: '4.0'

    settings partial: 'settings/redmine_issue_badge',
             default: {
               'activate_for_all_users' => 'false',
               'enabled_polling' => false,
               'number_to_display' => 5
             }

    Rails.configuration.to_prepare do
      require_dependency 'my_controller'
      MyController.prepend IssueBadge::MyControllerPatch unless MyController.included_modules.include?(IssueBadge::MyControllerPatch)
    end
  rescue ::Redmine::PluginRequirementError => e
    raise ::Redmine::PluginRequirementError.new(issue_badge_version_message(e.message)) # rubocop:disable Style/RaiseArgs
  end
end
