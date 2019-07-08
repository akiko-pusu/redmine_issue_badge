# frozen_string_literal: true

module LoginHelper
  def log_user(login, password)
    visit '/login'

    within('#login-form form') do
      fill_in 'username', with: login
      fill_in 'password', with: password
      find('input[name=login]').click
    end
  end
end
