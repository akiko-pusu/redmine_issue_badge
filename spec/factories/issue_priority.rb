# frozen_string_literal: true

FactoryBot.define do
  factory :priority, class: IssuePriority do
    sequence(:id, &:to_s)
    sequence(:name) { |n| "issue-priority: #{n}" }
    position { 0 }
    is_default { true }
    type { 'IssuePriority' }
    active { true }
    project_id { nil }
    parent_id { nil }
    position_name { 'default' }
  end
end
