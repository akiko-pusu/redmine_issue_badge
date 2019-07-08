# frozen_string_literal: true

class AddBadgeOrderToIssueBadgeUserSettings < ActiveRecord::Migration[4.2]
  def self.up
    add_column :issue_badge_user_settings, :badge_order, :integer, default: 0
  end

  def self.down
    remove_column :issue_badge_user_settings, :badge_order
  end
end

# For Redmine4.x user, especially under clean install:
# Please change ActiveRecord::Migration to ActiveRecord::Migration[4.2] in case
# migration failed.
