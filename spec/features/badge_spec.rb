# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../support/login_helper')

include LoginHelper

feature 'IssueBadge', js: true do
  let(:project) { FactoryBot.create(:project) }
  let(:tracker) { FactoryBot.create(:tracker, :with_default_status) }
  let(:role) { FactoryBot.create(:role) }
  let(:issue_priority) { FactoryBot.create(:priority) }
  let(:user) { FactoryBot.create(:user, :password_same_login, login: 'badge_user', language: 'en') }
  let(:issues) do
    FactoryBot.create_list(:issue, 4,
                            project_id: project.id,
                            tracker_id: tracker.id,
                            priority_id: issue_priority.id,
                            assigned_to_id: user.id)
  end

  context 'When anonymous' do
    scenario 'Badge is not displayed' do
      visit '/issues'
      expect(page).not_to have_selector('#issue_badge')
    end
  end

  context 'When authenticated' do
    background do
      log_user(user.login, user.login)
      visit '/my/account'
    end

    scenario 'Badge option is displayed on user preference page.' do
      expect(page.has_no_checked_field?('Show number of assigned issues with badge.')).to be_truthy
      expect(page).not_to have_selector('#issue_badge')
    end

    scenario 'Badge is displayed if badge option is activated' do
      # Enable Badge
      check 'issue_badge_enabled'
      click_on 'Save'

      expect(page).to have_selector('#issue_badge')
      expect(page).to have_selector("head > script[src*='javascripts/issue_badge.js']", visible: false)
    end

    context 'If badge option is activated and operator has assigned issues.' do
      background do
        project.trackers << tracker
        member = Member.new(project: project, user_id: user.id)
        member.member_roles << MemberRole.new(role: role)
        member.save
      end

      scenario 'Badge number is displayed.' do
        all_issues = issues
        # Enable Badge
        check 'issue_badge_enabled'
        click_on 'Save'
        expect(page).to have_selector('#issue_badge_number', text: all_issues.count)
      end

      scenario 'Assigned issues are displayed' do
        issue = issues.first
        issue.update_attributes(subject: '<b>HTML Subject</b>')
        all_issues = Issue.visible(user).to_a

        # Enable Badge
        check 'issue_badge_enabled'
        click_on 'Save'

        expect(page).to have_selector('#issue_badge_number', text: all_issues.length)

        find('#issue_badge_number').click
        expect(page).to have_css('#issue_badge_contents > div.issue_badge_content > a',
                                 text: "#{issue.id} <b>HTML Subject</b>")
        expect(page).not_to have_css('#issue_badge_contents > div.issue_badge_content > a.groups')
      end
    end

    context 'Setting issue_group_assignment is activated' do
      background do
        project.trackers << tracker

        Setting.issue_group_assignment = 1
        g = Group.new(name: 'New group', status: 1)
        g.users << user
        g.save
        member = Member.new(project: project, principal: g)
        member.member_roles << MemberRole.new(role: role)
        member.save
        FactoryBot.create(:issue, project_id: project.id,
                                   tracker_id: tracker.id, priority_id: issue_priority.id, assigned_to_id: g.id)
      end
      scenario 'Issue assigned to group is displayed.' do
        all_issues = issues

        # Enable Badge
        check 'issue_badge_enabled'
        click_on 'Save'
        expect(page).to have_selector('#issue_badge_number', text: all_issues.length)

        check 'issue_badge_enabled'
        check 'issue_badge_show_assigned_to_group'
        click_on 'Save'
        expect(page).to have_selector('#issue_badge_number', text: all_issues.length + 1)

        find('#issue_badge_number').click
        expect(page).to have_css('#issue_badge_contents > div.issue_badge_content > a.groups')
      end
    end
  end

  context 'When authenticated need password reset' do
    background do
      user.update_attribute(:must_change_passwd, true)
      log_user(user.login, user.login)
      visit '/my/account'
    end

    scenario 'Badge is not displayed if user need password reset' do
      expect(page).not_to have_selector("head > script[src$='javascripts/issue_badge.js']", visible: false)
      expect(page).not_to have_selector('#issue_badge')
    end
  end

  context 'When Administrator' do
    background do
      project.trackers << tracker
      member = Member.new(project: project, user_id: user.id)
      member.member_roles << MemberRole.new(role: role)
      member.save

      issues
      user.update_attribute(:admin, true)
      log_user(user.login, user.login)
      visit '/settings/plugin/redmine_issue_badge'
    end

    scenario 'Global settings for badge option is displayed.' do
      assert page.has_content?('Display issue badge for all users')
      expect(page).not_to have_selector('#issue_badge')
    end

    scenario 'Badge is displayed if global settings badge option is activated.' do
      # Enable Badge
      check 'settings_activate_for_all_users'
      click_on 'Apply'
      expect(page).to have_selector '#content > h2', text: /Redmine Issue Badge plugin/
      expect(page).to have_selector('#issue_badge')
    end

    scenario 'Badge is not displayed if global settings badge option is dectivated.' do
      # Enable Badge
      uncheck 'settings_activate_for_all_users'
      click_on 'Apply'
      expect(page).to have_selector '#content >h2', text: /Redmine Issue Badge plugin/
      expect(page).not_to have_selector('#issue_badge')
    end

    scenario 'Issue badge block is displayed if global settings badge option is activated and click badge.' do
      expect(page).not_to have_selector('#issue_badge_contents')

      check 'settings_activate_for_all_users'
      click_on 'Apply'
      find('#link_issue_badge').click
      expect(page).to have_selector('#issue_badge_contents')
    end

    scenario 'Issue badge polling is activate if polling option clicked.' do
      expect(page).not_to have_selector('#issue_badge_contents')

      check 'settings_activate_for_all_users'
      check 'settings_enabled_polling'
      click_on 'Apply'
      expect(page).to have_selector('#issue_badge')
      expect(page).to have_css('#issue_badge_number', text: issues.count)
      issues.first.delete
      within('#top-menu') do
        expect(page).to have_selector(:css, 'script', visible: false, count: 2)
        page.execute_script("poll('#{issue_badge_issues_count_path}');")
      end

      wait_for_ajax
      sleep 0.5 until has_css?('#issue_badge_number', text: issues.count - 1)
      expect(page).to have_css('#issue_badge_number', text: issues.count - 1)
    end
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
