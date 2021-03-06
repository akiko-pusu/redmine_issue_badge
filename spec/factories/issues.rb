# frozen_string_literal: true

FactoryBot.define do
  factory :issue do |i|
    association :project
    association :tracker
    i.sequence(:subject) { |n| "issue-subject: #{n}" }
    i.sequence(:description) { |n| "issue-description: #{n}" }
    i.assigned_to_id { nil }
    i.is_private { false }
    i.author_id { 1 }
    i.priority_id { 1 }

    trait :with_priority do
      after(:create) do |issue|
        priority = FactoryBot.create(:priority)
        issue.priority = priority
      end
    end
  end
end
