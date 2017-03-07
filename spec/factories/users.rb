# frozen_string_literal: true
FactoryGirl.define do
  factory :user do |u|
    # sequence -> exp. :login -> user1, user2.....
    u.sequence(:login)     { |n| "user#{n}" }
    u.sequence(:firstname) { |n| "User#{n}" }
    u.sequence(:lastname)  { |n| "Test#{n}" }
    u.sequence(:mail)      { |n| "user#{n}@badge.example.com" }
    u.language             'ja'
    # password = foo
    u.hashed_password      '8f659c8d7c072f189374edacfa90d6abbc26d8ed'
    u.salt                 '7599f9963ec07b5a3b55b354407120c0'

    trait :badge_user do
      login 'badge_user'
    end
  end
end
