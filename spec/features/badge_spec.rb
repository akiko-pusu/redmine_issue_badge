require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

feature 'Access Redmine top page', js: true do
  #
  # TODO: Change not to use Redmine's fixture but to use Factory...
  #
  fixtures :projects,
           :users, :email_addresses,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers

  context 'When anonymous ' do
    specify 'Badge is not displayed' do
      visit '/issues'
      expect(page).to have_title "Redmine"
      expect(page).not_to have_selector("#issue_badge")
    end
  end

  context 'When authenticated' do
    # Do login
    def log_user(login, password)
      visit '/my/page'
      assert_equal '/login', current_path
      within('#login-form form') do
        fill_in 'username', :with => login
        fill_in 'password', :with => password
        find('input[name=login]').click
        page.save_screenshot('capture/issues.png', :full => true)
      end
    end

    background do
      log_user('dlopper', 'foo')
      visit '/my/account'
    end

    scenario 'Badge is not displayed if badge option is not activated' do
      assert page.has_content?('Show number of assigned issues with badge.')
      expect(page).not_to have_selector("#issue_badge")
    end

    scenario 'Badge is displayed if badge option is activated' do
      assert page.has_content?('Show number of assigned issues with badge.')

      # Enable Badge
      check 'pref_issue_badge'
      click_on 'Save'

      expect(page).to have_selector("#issue_badge")

      user = User.where(:login => 'dlopper').first
      all_issues = Issue.visible.open.where(:assigned_to_id => ([user.id] + user.group_ids))
      puts "dlopper's issue: #{all_issues.length}"
      if all_issues.any?
        expect(page).to have_selector("#issue_badge_number")
        expect(page).to have_selector("#issue_badge_number"), text: all_issues.length

        puts "Badge count: " + find(:id, 'issue_badge_number').text
        page.save_screenshot('capture/badge.png', :full => true)
      end
    end


  end
end
