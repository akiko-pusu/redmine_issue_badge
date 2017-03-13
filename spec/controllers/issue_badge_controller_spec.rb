# frozen_string_literal: true
require_relative '../spec_helper'

describe IssueBadgeController do
  let(:user) { FactoryGirl.create(:user, status: 1) }
  let(:project) do
    FactoryGirl.create(:project)
  end
  let(:tracker) do
    FactoryGirl.create(:tracker, :with_default_status)
  end
  let(:role) { FactoryGirl.create(:role) }
  let(:issue_priority) { FactoryGirl.create(:priority) }

  describe 'GET #index' do
    before do
      project.trackers << tracker
      member = Member.new(project: project, user_id: user.id)
      member.member_roles << MemberRole.new(role: role)
      member.save
      @request.session[:user_id] = user.id

      FactoryGirl.create_list(:issue, issue_count,
                              project_id: project.id,
                              tracker_id: tracker.id,
                              priority_id: issue_priority.id,
                              assigned_to_id: user.id)
    end

    render_views
    context 'When assigned no issue.' do
      let(:issue_count) { 0 }
      it 'renders the _issue_badge template' do
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(/<span id="issue_badge_number" class="badge">0/im)
      end
    end

    context 'When assigned some issues' do
      let(:issue_count) { 4 }

      it 'renders the _issue_badge template' do
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(assigns(:all_issues_count)).to eq issue_count
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(%r{<span id="issue_badge_number" class="badge">#{issue_count}<\/span>}im)
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
        FactoryGirl.create(:issue, project_id: project.id,
                                   tracker_id: tracker.id, priority_id: issue_priority.id, assigned_to_id: g.id)
      end

      it 'renders the _issue_badge template' do
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(assigns(:all_issues_count)).to eq issue_count
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(%r{<span id="issue_badge_number" class="badge">#{issue_count}<\/span>}im)
      end

      it 'renders the _issue_badge template with assigned to group' do
        setting = IssueBadgeUserSetting.find_or_create_by_user_id(user.id)
        setting.update_attributes(show_assigned_to_group: true)
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(assigns(:all_issues_count)).to eq issue_count + 1
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(%r{<span id="issue_badge_number" class="badge">#{issue_count + 1}<\/span>}im)
      end
    end
  end

  describe 'GET #load_badge_contents' do
    before(:each) do
      @request.session[:user_id] = user.id
    end

    it 'renders the _issue_badge_contents template' do
      get :load_badge_contents
      expect(assigns(:limited_issues)).not_to be_nil
      expect(response).to render_template(partial: '_issue_badge_contents')
    end
  end

  describe 'GET #issues_count' do
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
        FactoryGirl.create_list(:issue, issue_count,
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
          expect(response.body).to match(/"status":true,"all_issues_count":0/)
        end
      end

      context 'has some issues' do
        let(:issue_count) { 2 }
        it 'return json with status true and assigned issues number.' do
          get :issues_count
          expect(response.body).to match(/"status":true,"all_issues_count":2/)
        end
      end
    end
  end
end
