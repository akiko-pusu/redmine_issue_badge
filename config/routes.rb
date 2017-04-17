Rails.application.routes.draw do
  get 'issue_badge', to: 'issue_badge#index'
  get 'issue_badge/load_badge_contents', to: 'issue_badge#load_badge_contents'
  get 'issue_badge/issues_count', to: 'issue_badge#issues_count'
end
