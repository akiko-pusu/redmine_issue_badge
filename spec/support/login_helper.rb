# frozen_string_literal: true

module LoginHelper
  def log_user(login, password)
    visit '/my/page'
    assert_equal '/login', current_path
    within('#login-form form') do
      fill_in 'username', with: login
      fill_in 'password', with: password
      find('input[name=login]').click
      # page.save_screenshot('capture/issues.png', full: true)
    end
  end
end
