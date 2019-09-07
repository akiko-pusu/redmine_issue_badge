# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe 'Issue Bage Setting at user preference page', type: :request do
  let(:user) { FactoryBot.create(:user, :password_same_login, login: 'test-manager', language: 'en', admin: false) }
  let(:issue_badge_user_setting) { IssueBadgeUserSetting.find_by(user_id: user.id) }

  before do
  end

  it 'issue_badge_user_setting is empty when access my account' do
    login_request(user.login, user.login)
    get '/my/account'
    expect(response.status).to eq 200
    expect(issue_badge_user_setting.blank?).to be_truthy
  end

  it 'issue_badge_user_setting is present after put data' do
    login_request(user.login, user.login)
    put '/my/account',
        params: { issue_badge: { enabled: 1 } }
    expect(response).to have_http_status(302)
    expect(issue_badge_user_setting.present?).to be_truthy
    expect(issue_badge_user_setting&.show_assigned_to_group?).to be_falsey
  end

  it 'issue_badge_user_setting is present after post data with _method param' do
    login_request(user.login, user.login)
    post '/my/account',
         params: { _method: 'put', issue_badge: { enabled: 1, show_assigned_to_group: 1 } }
    expect(response).to have_http_status(302)
    expect(issue_badge_user_setting.present?).to be_truthy
    expect(issue_badge_user_setting&.show_assigned_to_group?).to be_truthy
  end

  # Test support method

  def login_request(login, password)
    post '/login', params: { username: login, password: password }
  end
end
