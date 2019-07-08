# frozen_string_literal: true

class CreateIssueBadgeUserSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :issue_badge_user_settings do |t|
      t.integer :user_id
      t.boolean :enabled
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
    end
    add_index :issue_badge_user_settings, :user_id
  end

  def self.down
    remove_index :issue_badge_user_settings, :user_id
    drop_table :issue_badge_user_settings
  end
end

# For Redmine4.x user, especially under clean install:
# Please change ActiveRecord::Migration to ActiveRecord::Migration[4.2] in case
# migration failed.
