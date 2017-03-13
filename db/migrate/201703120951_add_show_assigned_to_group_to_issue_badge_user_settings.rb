# frozen_string_literal: true
class AddShowAssignedToGroupToIssueBadgeUserSettings < ActiveRecord::Migration
  def self.up
    add_column :issue_badge_user_settings, :show_assigned_to_group, :boolean
  end

  def self.down
    remove_column :issue_badge_user_settings, :show_assigned_to_group
  end
end
