Rails.application.routes.draw do
  get 'issue_badge', :to => 'issue_badge#index'
  get 'issue_badge/load_badge_contents', :to => 'issue_badge#load_badge_contents'
end
