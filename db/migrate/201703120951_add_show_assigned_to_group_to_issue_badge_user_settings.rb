# frozen_string_literal: true

class AddShowAssignedToGroupToIssueBadgeUserSettings < ActiveRecord::Migration[4.2]
  def self.up
    add_column :issue_badge_user_settings, :show_assigned_to_group, :boolean
  end

  def self.down
    remove_column :issue_badge_user_settings, :show_assigned_to_group
  end
end

# For Redmine4.x user, especially under clean install:
# Please change ActiveRecord::Migration to ActiveRecord::Migration[4.2] in case
# migration failed.
