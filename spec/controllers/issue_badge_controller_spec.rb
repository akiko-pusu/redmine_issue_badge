# frozen_string_literal: true

require_relative '../spec_helper'

describe IssueBadgeController, type: :controller do
  let(:user) { FactoryBot.create(:user, status: 1) }
  let(:assigned_user_id) { user.id }
  let(:project) do
    FactoryBot.create(:project)
  end
  let(:tracker) do
    FactoryBot.create(:tracker, :with_default_status)
  end
  let(:role) { FactoryBot.create(:role) }
  let(:issue_priority) { FactoryBot.create(:priority) }

  describe 'GET #index' do
    before do
      project.trackers << tracker
      member = Member.new(project: project, user_id: user.id)
      member.member_roles << MemberRole.new(role: role)
      member.save
      @request.session[:user_id] = user.id

      FactoryBot.create_list(:issue, issue_count,
                             project_id: project.id,
                             tracker_id: tracker.id,
                             priority_id: issue_priority.id,
                             assigned_to_id: assigned_user_id)
    end

    render_views
    context 'When assigned no issue.' do
      let(:issue_count) { 0 }
      it 'renders the _issue_badge template' do
        get :index
        expect(response.body).to match(/"all_issues_count":0/im)
      end
    end

    context 'When assigned some issues' do
      let(:issue_count) { 4 }

      it 'renders the _issue_badge template' do
        get :index
        expect(response.body).to match(/"all_issues_count":4/im)
      end
    end

    context 'When show_assigned_to_group option is checked.' do
      let(:issue_count) { 4 }
      before do
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

      it 'renders the _issue_badge template' do
        get :index
        expect(response.body).to match(/"all_issues_count":#{issue_count},"badge_color":"red"/im)
      end

      it 'renders the _issue_badge template with assigned to group' do
        setting = IssueBadgeUserSetting.find_or_create_by_user_id(user)
        setting.update(show_assigned_to_group: true)
        get :index
        expect(response.body).to match(/"all_issues_count":#{issue_count + 1},"badge_color":"red"/im)
      end
    end

    context 'when custom_query is selected that issues are not assigned to anyone.' do
      let(:issue_count) { 2 }
      let(:issue_query) { IssueQuery.first }

      before do
        query = IssueQuery.new(project: project, name: '_')
        query.visibility = IssueQuery::VISIBILITY_PUBLIC
        query.add_filter('assigned_to_id', '!*', [''])
        query.save

        setting = IssueBadgeUserSetting.find_or_create_by_user_id(user)
        setting.update(query_id: query.id)
      end

      context 'there are some issues are not assigned to anynone.' do
        # Issues are not assigned to anynone.
        let(:assigned_user_id) { nil }

        it 'renders the _issue_badge template with issue count: 2' do
          get :index
          expect(response.body).to match(/"all_issues_count":#{issue_count},"badge_color":"red"/im)
        end
      end

      context 'there are some issues are not assigned to me.' do
        # Issues are not assigned to anynone.
        let(:assigned_user) { user.id }

        it 'renders the _issue_badge template with issue count: 0' do
          get :index
          expect(response.body).to match(/"all_issues_count":0,"badge_color":"green"/im)
        end
      end
    end
  end

  describe 'GET #load_badge_contents' do
    render_views
    before(:each) do
      @request.session[:user_id] = user.id
    end

    it 'renders the _issue_badge_contents template' do
      get :load_badge_contents
      expect(response.body).to match(/<div id="issue_badge_contents" class="notifications arrow_box">/im)
    end

    context 'When assigned more than 5 issues' do
      let(:issue_count) { 7 }
      before do
        project.trackers << tracker
        member = Member.new(project: project, user_id: user.id)
        member.member_roles << MemberRole.new(role: role)
        member.save
        FactoryBot.create_list(:issue, issue_count,
                               project_id: project.id,
                               tracker_id: tracker.id,
                               priority_id: issue_priority.id,
                               assigned_to_id: user.id)

        @request.session[:user_id] = user.id
      end

      it '1st issue should not be included with order by asc when ' do
        # from 1 to 5
        get :load_badge_contents
        expect(response.body).to match(%r{class="users" href="/issues/1">1 issue-subject:})
      end

      it '1st issue should not be included with order by desc' do
        setting = IssueBadgeUserSetting.find_or_create_by_user_id(user)
        setting.update(badge_order: 1)

        # from 7 to 3
        get :load_badge_contents
        expect(response.body).to match(%r{class="users" href="/issues/7">7 issue-subject:})
      end
    end

    context 'When user select the query to find closed issues.' do
      let(:closed_status) { FactoryBot.create(:issue_status, is_closed: true) }
      before do
        project.trackers << tracker
        member = Member.new(project: project, user_id: user.id)
        member.member_roles << MemberRole.new(role: role)
        member.save
        FactoryBot.create(:issue,
                          project_id: project.id,
                          tracker_id: tracker.id,
                          priority_id: issue_priority.id,
                          assigned_to_id: nil)
        @request.session[:user_id] = user.id

        query = IssueQuery.new(project: project, name: '_')
        query.visibility = IssueQuery::VISIBILITY_PUBLIC
        query.filters = { 'status_id' => { operator: 'c', values: [''] } }
        query.save

        setting = IssueBadgeUserSetting.find_or_create_by_user_id(user)
        setting.query_id = query.id
        setting.save
      end

      context 'issue is opened' do
        it '0 closed issue should be displayed' do
          get :load_badge_contents
          expect(response.body).not_to match(%r{class="users" href="/issues/1">1 issue-subject:})
        end
      end

      context 'issue is closed' do
        before do
          issue = Issue.first
          issue.status = closed_status
          issue.save
        end

        it '1 closed issue should be displayed' do
          get :load_badge_contents
          expect(response.body).to match(%r{class="users" href="/issues/1">1 issue-subject:})
        end
      end
    end
  end

  describe 'GET #issues_count' do
    render_views
    context 'When anonymous' do
      it 'return json with status false.' do
        get :issues_count
        expect(response.body).to match(/"status":false/)
      end
    end

    context 'When Authenticated' do
      before do
        project.trackers << tracker
        member = Member.new(project: project, user_id: user.id)
        member.member_roles << MemberRole.new(role: role)
        member.save
        FactoryBot.create_list(:issue, issue_count,
                               project_id: project.id,
                               tracker_id: tracker.id,
                               priority_id: issue_priority.id,
                               assigned_to_id: user.id)

        @request.session[:user_id] = user.id
      end

      context 'has no issues' do
        let(:issue_count) { 0 }
        it 'return json with status true.' do
          get :issues_count
          expect(response.body).to match(/"status":true,"all_issues_count":0,"badge_color":"green"/)
        end
      end

      context 'has some issues' do
        let(:issue_count) { 2 }
        it 'return json with status true and assigned issues number.' do
          get :issues_count
          expect(response.body).to match(/"status":true,"all_issues_count":2,"badge_color":"red"/)
        end
      end
    end
  end
end
