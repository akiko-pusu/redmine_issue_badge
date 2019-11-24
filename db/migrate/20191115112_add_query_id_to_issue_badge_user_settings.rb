# frozen_string_literal: true

class AddQueryIdToIssueBadgeUserSettings < ActiveRecord::Migration[4.2]
  def self.up
    add_column :issue_badge_user_settings, :query_id, :integer
  end

  def self.down
    remove_column :issue_badge_user_settings, :query_id
  end
end

# For Redmine4.x user, especially under clean install:
# Please change ActiveRecord::Migration to ActiveRecord::Migration[4.2] in case
# migration failed.
