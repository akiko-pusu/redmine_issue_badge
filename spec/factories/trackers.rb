# frozen_string_literal: true

FactoryBot.define do
  factory :tracker do
    sequence(:name)     { |n| "tracker-name: #{n}" }
    sequence(:position) { |n| n }
    default_status_id 1
    trait :with_default_status do
      after(:build) do |tracker|
        status = FactoryBot.create(:issue_status)
        tracker.default_status_id = status.id
      end
    end

    # trait :with_project do
    trait :with_project do
      after(:build) do |tracker|
        project = FactoryBot.create(:project)
        project.trackers << tracker
      end
    end
  end
end
