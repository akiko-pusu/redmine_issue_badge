# frozen_string_literal: true
FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "project-name: #{n}" }
    sequence(:description) { |n| "project-description: #{n}" }
    sequence(:identifier) { |n| "project-#{n}" }
    homepage 'http://ecookbook.somenet.foo/'
    is_public true

    trait :with_issue_tracking do
      after(:create) do |project|
        tracker_module = FactoryBot.create(:enabled_module, name: 'issue_tracking', project_id: project.id)
        project.enabled_modules << tracker_module
      end
    end
  end
end
