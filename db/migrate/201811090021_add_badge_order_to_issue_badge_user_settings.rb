# frozen_string_literal: true

class AddBadgeOrderToIssueBadgeUserSettings < ActiveRecord::Migration
  def self.up
    add_column :issue_badge_user_settings, :badge_order, :integer, default: 0
  end

  def self.down
    remove_column :issue_badge_user_settings, :badge_order
  end
end
